//
//  RepoItemCellViewModel.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 21.06.2022.
//

class RepoItemCellViewModel {
    let repo: RepoItemModel
    var expanded: Bool = false
    var needShowMore: Bool = false
    
    init(repo: RepoItemModel) {
        self.repo = repo
    }
}
