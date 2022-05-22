//
//  AppCoordinator.swift
//  repoSearch
//
//  Created by Tetiana Sierikova on 22.05.2022.
//

import UIKit

class AppCoordinator {
    
    private let navigationController = UINavigationController()
    var rootViewController: UIViewController {
        return navigationController
    }
    
    func start() {
        navigationBarConfiguration(navigationController)
        showSearch()
    }
    
    private func showSearch() {
        let searchViewController = SearchViewController()
        navigationController.pushViewController(searchViewController, animated: true)
    }
    
    private func navigationBarConfiguration (_ controller: UINavigationController) {
        let navBarAppearance = UINavigationBarAppearance()
        controller.navigationBar.prefersLargeTitles = true
        controller.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        controller.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        controller.navigationBar.tintColor = .black
        navBarAppearance.backgroundColor = .white
        navBarAppearance.shadowImage = nil
        navBarAppearance.shadowColor = .none
        UINavigationBar.appearance().compactAppearance = navBarAppearance
    }
}
