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
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        runMainFlow()
    }
    
    private func runMainFlow() {
        
    }
}
