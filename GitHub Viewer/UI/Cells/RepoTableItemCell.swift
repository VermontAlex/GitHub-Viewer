//
//  RepoTableItemCell.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 18.06.2022.
//

import UIKit

protocol RepoItemCellDelegate {
    func repoItemDidSelected()
}

class RepoTableItemCell: UITableViewCell {

    @IBOutlet var repoName: UILabel!
    @IBOutlet var ownerName: UILabel!
    @IBOutlet var repoDescription: UILabel!
    @IBOutlet var stars: UILabel!
    
    static var cellReuseIdentifier = "RepoTableItemCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupWith(repo: RepoItemModel) {
        repoName.text = repo.name
        ownerName.text = repo.owner.login
        repoDescription.text = repo.itemDescription
        stars.text = String(repo.stargazersCount)
    }
}
