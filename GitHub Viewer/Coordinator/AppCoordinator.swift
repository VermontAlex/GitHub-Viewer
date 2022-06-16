//
//  AppCoordinator.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

class AppCoordinator: NSObject, CoordinatorProtocol, UINavigationControllerDelegate {
    
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController
    
    required init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToAuthCoordinator()
    }
    
    func goToAuthCoordinator() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.parentCoordinator = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    func goToHomeTabCoordinator(viewModel: HomeTabViewModel) {
        let homeTabCoordinator = HomeTabCoordinator(navigationController: navigationController, viewModel: viewModel)
        childCoordinators.append(homeTabCoordinator)
        homeTabCoordinator.start()
    }
    
    func childDidFinish(_ coordinator : CoordinatorProtocol?) {
        // Call this if a coordinator is done.
        for (index, child) in childCoordinators.enumerated() {
            if child === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
