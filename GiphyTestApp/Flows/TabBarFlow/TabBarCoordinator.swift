//
//  TabBarCoordinator.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

import UIKit

/// Coordinator responsible for handling the root TabBar presentation of the app
class TabBarCoordinator: BaseCoordinator {
    private var tabBarView: TabBarVC!
    private let router: Router
    private let giphyAPI: GiphyAPI
    private let filesService: FilesService
    private let coreDataStore: CoreDataStore
    
    init(router: Router, giphyAPI: GiphyAPI, filesService: FilesService, coreDataStore: CoreDataStore) {
        self.router = router
        self.giphyAPI = giphyAPI
        self.filesService = filesService
        self.coreDataStore = coreDataStore
    }
    
    /// Set up ``TabBarVC`` viewController, set closure for ``TabBarVC/onFlow`` to handle tabs switching
    override func start() {
        tabBarView = TabBarVC()
        tabBarView.onFlow = { [weak self] navController, itemType in
            self?.runItemFlow(navController: navController, itemType: itemType)
        }
        
        router.setNavigationBarHidden(true, animated: false)
        router.setViewControllers([tabBarView], animated: false)
        runItemFlow(navController: tabBarView.viewControllers?.first as? UINavigationController, itemType: .search)
    }
    
    /// Method that sets up Coordinator for the needed flow
    ///
    /// See makeTabBarCoordinatorItem for more info
    ///
    /// - Parameter navController: UINavigationController, root controller for the given tab
    /// - Parameter itemType: ``TabBarItemType`` case for the given tab
    private func runItemFlow(navController: UINavigationController?, itemType: TabBarItemType) {
        guard let navController = navController else {
            return
        }

        if navController.viewControllers.isEmpty {
            let itemCoordinator = self.makeTabBarCoordinatorItem(navController: navController, itemType: itemType)
            itemCoordinator.start()
            
            itemCoordinator.finishFlow = { [weak self, weak itemCoordinator] in
                self?.removeDependency(itemCoordinator)
                
                self?.finishFlow?()
            }
            
            self.addDependency(itemCoordinator)
        }
    }
        
    /// Creates Coordinator object for the given tab
    ///
    /// - Parameter navController: UINavigationController root controller for the given tab
    /// - Parameter itemType: ``TabBarItemType`` case for the given tab
    ///
    /// - Returns: ``Coordinatable`` instance, in our case it's either ``SearchCoordinator`` or ``SavedCoordinator``
    private func makeTabBarCoordinatorItem(navController: UINavigationController, itemType: TabBarItemType) -> Coordinatable {
        var coordinator: Coordinatable!
        switch itemType {
        case .search:
            coordinator = SearchCoordinator(
                router: navController,
                api: giphyAPI,
                filesService: filesService,
                coreDataStore: coreDataStore
            )
        case .saved:
            coordinator = SavedCoordinator(
                router: navController,
                coreDataStore: coreDataStore,
                filesService: filesService
            )
        }
        
        return coordinator
    }
}
