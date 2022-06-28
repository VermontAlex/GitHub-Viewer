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
    @IBOutlet var searchBar: UISearchBar!
    
    static let identifier = "HomeTabPageVC"
    static let storyboardName = "HomeTabPage"
    
    weak var coordinator: CoordinatorProtocol?
    var viewModel: HomeTabViewModel?
    
    private let gitManager = GitHubNetworkManager()
    private var searchedRepo = [RepoItemCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchBarStyle = .minimal
        fillHomeTab()
        initialFillTheTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureTableView()
    }
    
    private func configureTableView() {
        repoTableView.delegate = self
        repoTableView.dataSource = self
        repoTableView.separatorColor = .clear
        repoTableView.register(RepoTableItemCell.nib(), forCellReuseIdentifier: RepoTableItemCell.cellReuseIdentifier)
    }
    
    private func initialFillTheTable() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.searchByWord = "GitHub-Viewer"
        viewModel.paginationNumber = 1
        
        fillTheTable(pagination: viewModel.paginationNumber, searchedWord: viewModel.searchByWord)
    }
    
    private func fillTheTable(pagination: Int, searchedWord: String) {
        guard let viewModel = viewModel,
              let dataToken = try? KeyChainManager.get(account: viewModel.account.login, service: viewModel.service),
              let token = String(data: dataToken, encoding: String.Encoding.utf8) else {
                  return
              }
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        gitManager.searchForRepos(byName: searchedWord,
                                  pageNum: pagination,
                                  token: token) { result in
            switch result {
            case .success(let repos):
                let reposViewModel = repos.items.map { repo in
                    return RepoItemCellViewModel(repo: repo)
                }
                self.searchedRepo.append(contentsOf: reposViewModel)
                
                dispatchGroup.leave()
            case .failure(let error):
                ErrorHandlerService.unknownedError.handleErrorWithDB(error: error)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.wait()
        
        dispatchGroup.enter()
        gitManager.searchForRepos(byName: searchedWord,
                                  pageNum: pagination + 1,
                                  token: token) { result in
            switch result {
            case .success(let repos):
                let reposViewModel = repos.items.map { repo in
                    return RepoItemCellViewModel(repo: repo)
                }
                self.searchedRepo.append(contentsOf: reposViewModel)
                viewModel.paginationNumber += 2
                dispatchGroup.leave()
            case .failure(let error):
                ErrorHandlerService.unknownedError.handleErrorWithDB(error: error)
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.repoTableView.reloadData()
        }
    }
    
    private func fillHomeTab() {
        guard let viewModel = viewModel else { return fillHomeTabDefault() }
        welcomeLabel.text = "Hello, \(viewModel.account.login)!"
        welcomeLabel.font = UIFont.sf(style: .bold, size: 50)
        self.transitioningDelegate = viewModel.customTransition
    }
    
    private func fillHomeTabDefault() {
        welcomeLabel.font = UIFont.sf(style: .bold, size: 20)
        welcomeLabel.text = "Welcome!"
    }
    
    @IBAction func searchRepoButton(_ sender: UIButton) {
        guard let viewModel = viewModel else {
            return
        }
        fillTheTable(pagination: viewModel.paginationNumber, searchedWord: viewModel.searchByWord)
    }
}

extension HomeTabPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedRepo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = repoTableView.dequeueReusableCell(withIdentifier: RepoTableItemCell.cellReuseIdentifier, for: indexPath)
        if let cell = cell as? RepoTableItemCell {
            let viewModel = searchedRepo[indexPath.row]
            cell.setupWith(viewModel: viewModel)
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
}

extension HomeTabPageVC: RepoItemCellDelegate {
    
    func updateCellHeight(vm: RepoItemCellViewModel?, inBlock: () -> Void) {
        if let vm = vm {
            for cellViewModel in searchedRepo {
                if cellViewModel === vm {
                    continue
                }

                cellViewModel.expanded = false
            }
        }

        inBlock()
        self.repoTableView.reloadData()
    }
}
