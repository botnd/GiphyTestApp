//
//  ApplicationCoordinator.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

import UIKit

typealias Router = UINavigationController

class ApplicationCoordinator: BaseCoordinator {
    private let router: Router
    private let giphyAPI: GiphyAPI = GiphyApiDefaultImpl()
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        runMainFlow()
    }
    
    private func runMainFlow() {
        let coordinator = TabBarCoordinator(router: router, giphyAPI: giphyAPI)
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
}
