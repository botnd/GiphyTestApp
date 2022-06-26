//
//  SearchVM.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

import Combine
import Kingfisher

/// ViewModel class for ``SearchVC`` viewController
class SearchVM {
    
    var onGifTapped: GifAction?
    
    private let api: GiphyAPI
    private let filesService: FilesService
    private let coreDataStore: CoreDataStore

    private var gifsCancellable: AnyCancellable?
    private var searchCancellable: AnyCancellable?
    private var saveCancellable: AnyCancellable?
    private var savedGifsCancellable: AnyCancellable?
    
    @Published
    private var cells: [SearchCellVM] = []
    var cellsPublisher: Published<[SearchCellVM]>.Publisher {
        $cells
    }
    
    private var offset: Int = 0
    
    @Published
    var searchQuery: String?
    
    init(api: GiphyAPI, filesService: FilesService, coreDataStore: CoreDataStore) {
        self.api = api
        self.filesService = filesService
        self.coreDataStore = coreDataStore
        
        loadData()
        
        searchCancellable = $searchQuery.sink { [weak self] query in
            self?.offset = 0
            self?.loadData(for: query)
        }
    }
    
    /// Performs network request to Giphy API
    ///
    /// Uses ``GiphyAPI`` for these requests
    ///
    /// Will call ``GiphyAPI/loadTrending(offset:count:)`` if query parameter is nil
    ///
    /// - Parameter query: Optional String parameter containing search query,
    /// ``GiphyAPI/loadSearch(_:offset:count:)`` method will be called if this is not nil
    ///
    /// Calls ``mapCells`` method after receiving data
    ///
    /// Also performs a call to ``CoreDataStore`` ``CoreDataStore/publisher(fetch:)-26rwq`` method to
    /// load previously saved GIFs in order to update cells to show which ones have already been favourited
    private func loadData(for query: String? = nil) {
        gifsCancellable?.cancel()
        
        let task: AnyPublisher<([Gif], Pagination), Never>
        if let query = query, !query.isEmpty {
            task = api.loadSearch(query, offset: offset, count: 48)
        } else {
            task = api.loadTrending(offset: offset, count: 48)
        }
        
        gifsCancellable = task.compactMap { [weak self] res in
            self?.offset += res.1.count
            
            return res.0
        }.sink { gifs in
            self.mapCells(gifs)
        }
        
        let request = NSFetchRequest<SavedGif>(entityName: SavedGif.entity().name!)
        savedGifsCancellable = coreDataStore.publisher(fetch: request)
            .replaceError(with: [])
            .combineLatest(task)
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .sink { [weak self] savedGifs in
                self?.updateCells(savedGifs.0)
            }
    }
    
    /// Creates ``SearchCellVM`` viewModels from input
    ///
    /// - Parameter gifs: array of ``Gif``
    ///
    /// also sets up handling of ``SaveButton`` tap in ``SearchCell``
    private func mapCells(_ from: [Gif]) {
        cells = from.map { gif in
            SearchCellVM(gif: gif) { [weak self] gif in
                self?.saveGif(gif)
            }
        }
    }
    
    /// Sets ``Gif/saved`` property on ``Gif`` objects and ``SearchCellVM/isSaved`` property in cells viewModels
    /// after fetching GIFs stored in CoreData, so that previously stored GIFs can be properly indicated
    ///
    /// - Parameter saved: array of ``SavedGif`` objects
    private func updateCells(_ saved: [SavedGif]) {
        cells.forEach { cell in
            if let saved = saved.first(where: { $0.gifId == cell.gif.id }) {
                cell.gif.saved = saved
                cell.isSaved = true
            } else {
                cell.isSaved = false
            }
        }
    }
    
    /// Handler for tapping on GIF
    ///
    /// will call ``SearchVM/onGifTapped`` closure resulting in ``SearchCoordinator`` showing this GIF fullscreen
    ///
    /// - Parameter index: Integer of tapped GIF
    func tapGif(_ index: Int) {
        if let vm = cells[safeIndex: index] {
            onGifTapped?(vm.gif)
        }
    }
    
    
    /// Calls for saving or removal of ``Gif``
    ///
    /// If ``Gif/saved`` property is not nil ``SavedGif`` will be removed
    /// Utilizes ``FilesService`` ``FilesService/removeImage(id:)`` and ``CoreDataStore`` ``CoreDataStore/publisher(delete:)-5ej8a``
    /// methods
    ///
    /// In the other case ``FilesService`` ``FilesService/saveImage(_:)`` and ``CoreDataStore`` ``CoreDataStore/publisher(save:)-9h5n8``
    /// methods will be called to store GIF locally
    ///
    /// - Parameter gif: ``Gif`` to be saved
    private func saveGif(_ gif: Gif) {
        if let saved = gif.saved {
            saveCancellable = coreDataStore.publisher(delete: saved)
                .replaceError(with: false)
                .flatMap { [unowned self] _ in self.filesService.removeImage(id: gif.id) }
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .sink { _ in }
        } else {
            saveCancellable = filesService.saveImage(gif)
                .flatMap { [unowned self] in
                    self.coreDataStore.publisher { context in
                        let saved = SavedGif(context: context)
                        saved.gifId = gif.id
                        saved.width = gif.original?.width ?? 0
                        saved.height = gif.original?.height ?? 0
                    }
                }
                .replaceError(with: false)
                .sink {_ in }
        }
    }
}
