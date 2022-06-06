//
//  LoginPageVC.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

class LoginPageVC: UIViewController, StoryboardedProtocol {
    
    static let identifier = "LoginPageVC"
    static let storyboardName = "LoginPage"
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
