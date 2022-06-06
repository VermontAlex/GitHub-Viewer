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
        navigationController.delegate = self
        let vc = LoginPageVC.instantiateCustom(storyboard: LoginPageVC.storyboardName)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let loginPageViewController = fromViewController as? LoginPageVC {
            self.childDidFinish(loginPageViewController.coordinator)
        }
    }
}
