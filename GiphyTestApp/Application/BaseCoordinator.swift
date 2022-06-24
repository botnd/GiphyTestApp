//
//  BaseCoordinator.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

protocol Coordinatable: AnyObject {
    var finishFlow: Action? { get set }
    func start()
}

class BaseCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var finishFlow: Action?
    func start() {}
    
    func addDependency(_ coordinator: Coordinatable) {
        for element in childCoordinators where element === coordinator {
            return
        }
        
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinatable?) {
        guard !childCoordinators.isEmpty,
              let coordinator = coordinator else {
            return
        }
        
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
    
    deinit {
        print(self, " deinit")
    }
}
