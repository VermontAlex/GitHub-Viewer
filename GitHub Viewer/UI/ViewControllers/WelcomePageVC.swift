//
//  WelcomePageVC.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

class WelcomePageVC: UIViewController, StoryboardedProtocol {
    
    @IBOutlet var loginButton: UIButton!
    
    static let identifier = "WelcomePageVC"
    static let storyboardName = "WelcomePage"
    
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        coordinator?.goToAuthCoordinator()
    }
}
