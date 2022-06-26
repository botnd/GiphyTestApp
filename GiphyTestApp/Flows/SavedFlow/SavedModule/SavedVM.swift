//
//  SavedVM.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 26.06.2022.
//

import Combine

/// ViewModel class for ``SavedVC`` viewController
class SavedVM {
    let coreDataStore: CoreDataStore
    let filesService: FilesService
    
    private var fetchCancellable: AnyCancellable?
    private var removeCancellable: AnyCancellable?
    
    @Published
    private var cells: [SavedCellVM] = []
    var cellsPublisher: Published<[SavedCellVM]>.Publisher {
        $cells
    }
    
    init(coreDataStore: CoreDataStore, filesService: FilesService) {
        self.coreDataStore = coreDataStore
        self.filesService = filesService
        
        loadData()
    }
    
    /// Performs fetch request on CoreData database
    ///
    /// Uses ``CoreDataStore/publisher(fetch:)-8o05o`` for this request
    ///
    /// Calls ``mapCells`` method after receiving data
    private func loadData() {
        let request = NSFetchRequest<SavedGif>(entityName: SavedGif.entity().name!)
        fetchCancellable = coreDataStore.publisher(fetch: request)
            .replaceError(with: [])
            .sink { [weak self] gifs in
                self?.mapCells(gifs)
            }
    }
    
    /// Creates ``SavedCellVM`` viewModels from input
    ///
    /// - Parameter gifs: array of ``SavedGif``
    ///
    /// also sets up handling of ``SaveButton`` tap in ``SavedCell``
    private func mapCells(_ gifs: [SavedGif]) {
        self.cells = gifs.map {
            SavedCellVM(gif: $0) { [weak self] gif in
                self?.removeGif(gif)
            }
        }
    }
    
    /// Calls for removal of locally stored ``SavedGif`` from both CoreData database and documents directory
    ///
    /// Utilizes ``FilesService`` ``FilesService/removeImage(id:)`` and ``CoreDataStore`` ``CoreDataStore/publisher(delete:)-5ej8a``
    /// methods
    ///
    /// - Parameter gif: ``SavedGif`` to be removed
    private func removeGif(_ gif: SavedGif) {
        guard let gifId = gif.gifId else {return}
        removeCancellable = coreDataStore.publisher(delete: gif)
            .replaceError(with: false)
            .flatMap { [unowned self] _ in self.filesService.removeImage(id: gifId) }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { _ in }
    }
    
    /// Method for getting ``SavedCellVM`` at given index
    ///
    /// performs safe check within cells array
    /// - Parameter for: Integer index of needed VM
    ///
    /// - Returns: ``SavedCellVM`` optional 
    func getVM(for index: Int) -> SavedCellVM? {
        cells[safeIndex: index]
    }
}
