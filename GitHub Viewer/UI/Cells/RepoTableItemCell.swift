//
//  RepoTableItemCell.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 18.06.2022.
//

import UIKit

class RepoTableItemCell: UITableViewCell {

    @IBOutlet var repoName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
