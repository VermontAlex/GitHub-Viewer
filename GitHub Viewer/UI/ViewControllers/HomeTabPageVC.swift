//
//  ViewController.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

class HomeTabPageVC: UIViewController, StoryboardedProtocol {
    
    @IBOutlet var repoTableView: UITableView!
    @IBOutlet var welcomeLabel: UILabel!
    
    static let identifier = "HomeTabPageVC"
    static let storyboardName = "HomeTabPage"
    
    weak var coordinator: CoordinatorProtocol?
    var viewModel: HomeTabViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillHomeTab()
        configureTableView()
    }
    
    private func configureTableView() {
        guard let viewModel = viewModel else { return }
        
    }
    
    private func fillHomeTab() {
        guard let viewModel = viewModel else { return fillHomeTabDefault() }
        welcomeLabel.text = viewModel.account.login
        self.transitioningDelegate = viewModel.customTransition
    }
    
    private func fillHomeTabDefault() {
        welcomeLabel.text = "Welcome!"
    }
}
