//
//  MainCoordinator.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

final class AuthCoordinator: NSObject, CoordinatorProtocol, UINavigationControllerDelegate {
    
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.overrideUserInterfaceStyle = .light
    }
    
    func start() {
        let vc = LoginPageVC.instantiateCustom(storyboard: LoginPageVC.storyboardName)
        vc.coordinator = self
        vc.gitApiManager = GitHubNetworkManager()
        vc.viewModel = LoginViewModel()
        navigationController.pushViewController(vc, animated: true)
    }

    func stop() {
        parentCoordinator?.childDidFinish(self)
    }
}
