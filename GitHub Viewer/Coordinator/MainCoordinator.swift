//
//  MainCoordinator.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

final class MainCoordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.overrideUserInterfaceStyle = .light
    }
    
    func startHomePage() {
        let vc = HomeScreenVC.instantiateCustom(storyboard: HomeScreenVC.storyboardName)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func startLoginPage() {
        let vc = LoginPageVC.instantiateCustom(storyboard: LoginPageVC.storyboardName)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
