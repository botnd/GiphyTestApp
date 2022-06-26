//
//  SavedVM.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 26.06.2022.
//

import Combine

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
    
    private func loadData() {
        let request = NSFetchRequest<SavedGif>(entityName: SavedGif.entity().name!)
        fetchCancellable = coreDataStore.publisher(fetch: request)
            .replaceError(with: [])
            .sink { [weak self] gifs in
                self?.mapCells(gifs)
            }
    }
    
    private func mapCells(_ gifs: [SavedGif]) {
        self.cells = gifs.map {
            SavedCellVM(gif: $0) { [weak self] gif in
                self?.removeGif(gif)
            }
        }
    }
    
    private func removeGif(_ gif: SavedGif) {
        guard let gifId = gif.gifId else {return}
        removeCancellable = coreDataStore.publisher(delete: gif)
            .replaceError(with: false)
            .flatMap { [unowned self] _ in self.filesService.removeImage(id: gifId) }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { _ in }
    }
    
    func getVM(for index: Int) -> SavedCellVM? {
        cells[safeIndex: index]
    }
}
