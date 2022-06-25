//
//  SearchCoordinator.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

class SearchCoordinator: BaseCoordinator {
    private let router: Router
    private let api: GiphyAPI
    
    init(router: Router, api: GiphyAPI) {
        self.router = router
        self.api = api
    }
    
    override func start() {
        showSearchModule()
    }
    
    private func showSearchModule() {
        let vc = SearchVC()
        let vm = SearchVM(api: api)
        
        vc.viewModel = vm
        
        router.setViewControllers([vc], animated: false)
    }
}
