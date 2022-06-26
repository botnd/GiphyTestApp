//
//  SearchCoordinator.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

/// Coordinator class responsible for content of the `Search` tab
class SearchCoordinator: BaseCoordinator {
    private let router: Router
    private let api: GiphyAPI
    private let filesService: FilesService
    private let coreDataStore: CoreDataStore
    
    init(router: Router, api: GiphyAPI, filesService: FilesService, coreDataStore: CoreDataStore) {
        self.router = router
        self.api = api
        self.filesService = filesService
        self.coreDataStore = coreDataStore
    }
    
    override func start() {
        showSearchModule()
    }
    
    /// Shows initial screen containing ``SearchVC`` viewController
    ///
    /// Displays trending or searched GIFs in UICollectionVIew
    private func showSearchModule() {
        let vc = SearchVC()
        let vm = SearchVM(api: api, filesService: filesService, coreDataStore: coreDataStore)
        vm.onGifTapped = { [weak self] gif in
            self?.showGifViewModule(gif)
        }
        vc.viewModel = vm
        
        router.setViewControllers([vc], animated: false)
    }
    
    /// Shows ``GifViewVC`` viewController
    ///
    /// Displays selected GIF in a large UIImageView view
    ///
    /// - Parameter gif: ``Gif`` to be displayed
    private func showGifViewModule(_ gif: Gif) {
        let vc = GifViewVC()
        let vm = GifViewVM(gif: gif)
        
        vc.viewModel = vm
    
        router.pushViewController(vc, animated: true)
    }
}
