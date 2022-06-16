//
//  ViewController.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

class HomeScreenVC: UIViewController, StoryboardedProtocol {
    
    @IBOutlet var welcomeLabel: UILabel!
    
    static let identifier = "HomeScreenVC"
    static let storyboardName = "HomeScreen"
    
    weak var coordinator: CoordinatorProtocol?
    var viewModel: HomeTabViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillHomeTab()
        fetchRepoRelated()
    }
    
    private func fetchRepoRelated() {
        print(viewModel?.tokenToUse)
    }
    
    private func fillHomeTab() {
        guard let viewModel = viewModel else { return fillHomeTabDefault() }
        welcomeLabel.text = viewModel.account.login
    }
    
    private func fillHomeTabDefault() {
        welcomeLabel.text = "Welcome!"
    }
}
