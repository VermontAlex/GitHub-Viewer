//
//  WelcomePageVC.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

class WelcomePageVC: UIViewController, StoryboardedProtocol {
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var welcomeTitle: UILabel!
    
    static let identifier = "WelcomePageVC"
    static let storyboardName = "WelcomePage"
    
    weak var coordinator: AppCoordinator?
    var viewModel: WelcomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInformation()
        setWelcomeTitle()
    }
    
    private func fillInformation() {
        guard viewModel != nil else { return }
        loginButton.setTitle(viewModel?.buttonTitle, for: .normal)
        welcomeTitle.text = viewModel?.greetings
    }
    
    private func setWelcomeTitle() {
        welcomeTitle.numberOfLines = 0
        welcomeTitle.textColor = .systemBlue
        welcomeTitle.font = UIFont.sf(style: .semibold, size: 50)
        welcomeTitle.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func loginButton(_ sender: Any) {
        coordinator?.goToAuthCoordinator()
    }
}
