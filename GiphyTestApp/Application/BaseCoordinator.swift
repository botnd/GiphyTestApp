//
//  BaseCoordinator.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

/// Type that can Coordinate app logic
protocol Coordinatable: AnyObject {
    /// Called when the flow of this Coordinator has ended
    ///
    /// You should call for ``BaseCoordinator/removeDependency(_:)`` in this closure to prevent memory leaks
    var finishFlow: Action? { get set }
    
    /// Initial starting point for the flow of the Coordinator
    func start()
}

class BaseCoordinator: Coordinatable {
    /// Property that stores Coordinators, so that they are not released from memory be ARC
    private var childCoordinators: [Coordinatable] = []
    
    var finishFlow: Action?
    func start() {}
    
    /// Inserts ``Coordinatable`` to the childCoordinators array after performing unique-check
    func addDependency(_ coordinator: Coordinatable) {
        for element in childCoordinators where element === coordinator {
            return
        }
        
        childCoordinators.append(coordinator)
    }
    
    /// Removes ``Coordinatable`` from the childCoordinators array after it's flow was finished
    /// so that it can be released from memory
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
