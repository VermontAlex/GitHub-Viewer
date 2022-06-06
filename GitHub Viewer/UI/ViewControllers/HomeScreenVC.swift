//
//  ViewController.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

class HomeScreenVC: UIViewController, StoryboardedProtocol {
    
    static let identifier = "HomeScreenVC"
    static let storyboardName = "HomeScreen"
    
    weak var coordinator: AuthCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
