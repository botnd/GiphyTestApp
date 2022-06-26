//
//  SearchCoordinator.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

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
    
    private func showSearchModule() {
        let vc = SearchVC()
        let vm = SearchVM(api: api, filesService: filesService, coreDataStore: coreDataStore)
        vm.onGifTapped = { [weak self] gif in
            self?.showGifViewModule(gif)
        }
        vc.viewModel = vm
        
        router.setViewControllers([vc], animated: false)
    }
    
    private func showGifViewModule(_ gif: Gif) {
        let vc = GifViewVC()
        let vm = GifViewVM(gif: gif)
        
        vc.viewModel = vm
    
        router.pushViewController(vc, animated: true)
    }
}
