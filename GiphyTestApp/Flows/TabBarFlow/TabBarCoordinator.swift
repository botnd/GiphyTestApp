//
//  TabBarCoordinator.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

import UIKit

class TabBarCoordinator: BaseCoordinator {
    private var tabBarView: TabBarVC!
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        tabBarView = TabBarVC()
        tabBarView.onFlow = { [weak self] navController, itemType in
            self?.runItemFlow(navController: navController, itemType: itemType)
        }
        
        router.setNavigationBarHidden(true, animated: false)
        router.setViewControllers([tabBarView], animated: false)
        runItemFlow(navController: tabBarView.viewControllers?.first as? UINavigationController, itemType: .search)
    }
    
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
    
    private func makeTabBarCoordinatorItem(navController: UINavigationController, itemType: TabBarItemType) -> Coordinatable {
        var coordinator: Coordinatable!
        switch itemType {
        case .search:
            coordinator = SearchCoordinator(router: navController)
        case .saved:
            coordinator = nil // TODO: set savedCoordinator
        }
        
        return coordinator
    }
}
