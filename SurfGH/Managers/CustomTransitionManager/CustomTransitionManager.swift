//
//  CustomTransitionManager.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 16.06.2022.
//

import UIKit

final class CustomTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    
    let transitionAnimation: UIViewControllerAnimatedTransitioning
    
    init(transitionAnimation: UIViewControllerAnimatedTransitioning) {
        self.transitionAnimation = transitionAnimation
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimation
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimation
    }
}
