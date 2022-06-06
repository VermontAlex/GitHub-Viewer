//
//  Coordinator.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    
    var childCoordinators: [CoordinatorProtocol] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
    func childDidFinish(_ coordinator : CoordinatorProtocol?)
}
