//
//  LoginPageVC.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

class LoginPageVC: UIViewController, StoryboardedProtocol {
    
    @IBOutlet var loginPageTitle: UILabel!
    
    static let identifier = "LoginPageVC"
    static let storyboardName = "LoginPage"
    
    weak var coordinator: CoordinatorProtocol?
    var viewModel: LoginViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setUpViewModel(viewModel: LoginViewModelProtocol) {
        guard self.viewModel != nil else { return }
        self.loginPageTitle.text = viewModel.title
    }
}
