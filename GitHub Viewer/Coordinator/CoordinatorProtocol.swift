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
}

extension CoordinatorProtocol {
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
