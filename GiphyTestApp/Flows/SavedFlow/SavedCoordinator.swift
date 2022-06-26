//
//  SavedCoordinator.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 26.06.2022.
//

/// Coordinator class responsible for content of the `Saved` tab
class SavedCoordinator: BaseCoordinator {
    private let router: Router
    private let coreDataStore: CoreDataStore
    private let filesService: FilesService
    
    init(router: Router, coreDataStore: CoreDataStore, filesService: FilesService) {
        self.router = router
        self.coreDataStore = coreDataStore
        self.filesService = filesService
    }
    
    override func start() {
        showSavedModule()
    }
    
    /// Shows initial screen containing ``SavedVC`` viewController
    ///
    /// Displays previously saved GIFs in UITableView
    private func showSavedModule() {
        let vc = SavedVC()
        let vm = SavedVM(
            coreDataStore: coreDataStore,
            filesService: filesService
        )
        
        vc.viewModel = vm
        
        router.setViewControllers([vc], animated: false)
    }
}
