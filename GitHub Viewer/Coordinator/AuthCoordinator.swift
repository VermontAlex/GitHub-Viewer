//
//  MainCoordinator.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

final class AuthCoordinator: NSObject, CoordinatorProtocol, UINavigationControllerDelegate {
    
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.overrideUserInterfaceStyle = .light
    }
    
    func start() {
        let loginViewModel = LoginViewModel()
        let vc = LoginPageVC.instantiateCustom(storyboard: LoginPageVC.storyboardName)
        vc.coordinator = self
        vc.gitApiManager = GitHubNetworkManager()
        vc.viewModel = loginViewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func stop() {
        childDidFinish(self)
    }
    
    func childDidFinish(_ coordinator : CoordinatorProtocol?){
       // Call this if a coordinator is done.
       for (index, child) in childCoordinators.enumerated() {
           if child === coordinator {
               childCoordinators.remove(at: index)
               break
           }
       }
   }
}
