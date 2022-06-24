//
//  TabBarVC.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

import UIKit

enum TabBarItemType: Int {
    case search = 0
    case saved = 1
}

final class TabBarVC: UITabBarController {
    var onFlow: ((UINavigationController, TabBarItemType) -> Void)?
    var onViewDidLoad: ((UINavigationController) -> Void)?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        selectedViewController?.preferredStatusBarStyle ?? .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setupUI()
        if let viewController = customizableViewControllers?.first as? UINavigationController {
            onViewDidLoad?(viewController)
        }
    }
    
    private func setupUI() {
        let tabs = [UITabBarItem(), UITabBarItem()]
        let tabVCs = [UINavigationController(), UINavigationController()]
        
        zip(tabs, tabVCs).forEach { $0.1.tabBarItem = $0.0 }
        setViewControllers(tabVCs, animated: true)
        
        if let items = self.tabBar.items {
            for (index, item) in items.enumerated() {
                switch TabBarItemType(rawValue: index) {
                case .search:
                    item.title = R.string.localizable.tabBarItemsSearch()
                case .saved:
                    item.title = R.string.localizable.tabBarItemsSaved()
                default:
                    break
                }
            }
        }
        
        self.tabBar.tintColor = .blue
        self.tabBar.barTintColor = .black
        UITabBar.appearance().backgroundColor = .white
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
    }
    
    func updateTabBarItem(with item: TabBarItemType) {
        guard let controller = viewControllers?[item.rawValue] as? UINavigationController else {return}
        selectedIndex = item.rawValue
        onFlow?(controller, item)
    }
}

extension TabBarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else {return}
        onFlow?(controller, TabBarItemType(rawValue: selectedIndex)!)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
