//
//  HomeTabCoordinator.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 15.06.2022.
//

import UIKit

protocol HomeTabCoordinatorProtocol {
    func start(viewModel: HomeTabViewModel)
}

class HomeTabCoordinator: CoordinatorProtocol {
    
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [CoordinatorProtocol] = []
    
    var navigationController: UINavigationController
    var viewModel: HomeTabViewModel
    
    required init(navigationController : UINavigationController, viewModel: HomeTabViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let vc = HomeScreenVC.instantiateCustom(storyboard: HomeScreenVC.storyboardName)
        vc.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func stop() {
        parentCoordinator?.childDidFinish(self)
    }
}
