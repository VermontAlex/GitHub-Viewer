//
//  AppCoordinator.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = WelcomePageVC.instantiateCustom(storyboard: WelcomePageVC.storyboardName)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToAuthCoordinator() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
}
