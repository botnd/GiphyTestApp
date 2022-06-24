//
//  SearchCoordinator.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

class SearchCoordinator: BaseCoordinator {
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        showSearchModule()
    }
    
    private func showSearchModule() {
        let vc = SearchVC()
        let vm = SearchVM()
        
        vc.viewModel = vm
        
        router.setViewControllers([vc], animated: false)
    }
}
