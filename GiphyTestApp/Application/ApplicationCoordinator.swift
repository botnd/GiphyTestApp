//
//  ApplicationCoordinator.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

import UIKit

typealias Router = UINavigationController

/// Main application Coordinator class
///
/// Initializes and sets up ``TabBarCoordinator`` and all of it's dependencies
class ApplicationCoordinator: BaseCoordinator {
    private let router: Router
    private let giphyAPI: GiphyAPI = GiphyApiDefaultImpl()
    private let filesService: FilesService = FilesServiceDefaultImpl()
    private let coreDataStore: CoreDataStore = CoreDataStoreDefaultImpl.default
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        runMainFlow()
    }
    
    private func runMainFlow() {
        let coordinator = TabBarCoordinator(
            router: router,
            giphyAPI: giphyAPI,
            filesService: filesService,
            coreDataStore: coreDataStore
        )
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
}
