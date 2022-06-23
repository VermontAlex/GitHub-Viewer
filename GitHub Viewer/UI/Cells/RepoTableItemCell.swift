//
//  RepoTableItemCell.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 18.06.2022.
//

import UIKit

protocol RepoItemCellDelegate: AnyObject {
    func updateCellHeight(vm: RepoItemCellViewModel?, inBlock:() -> Void)
}

class RepoTableItemCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var repoName: UILabel!
    @IBOutlet var ownerName: UILabel!
    @IBOutlet var repoDescriptionTextView: UITextView!
    @IBOutlet var descriptionHightConstraint: NSLayoutConstraint!
    @IBOutlet var stars: UILabel!
    @IBOutlet var showMoreButton: UIButton!
    
    static var cellReuseIdentifier = "RepoTableItemCell"
    
    let maxDescriptionHeight = CGFloat(62)
    
    private var frameObserver: NSKeyValueObservation?
    weak var delegate: RepoItemCellDelegate?
    weak var viewModel: RepoItemCellViewModel?
    
    deinit {
        self.frameObserver?.invalidate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.frameObserver?.invalidate()
        self.observeFrame()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainView?.layer.borderColor = UIColor.gray.cgColor
        self.mainView?.layer.borderWidth = 1.0
        self.mainView.backgroundColor = .systemBackground
        self.mainView?.dropShadow(cornerRadius: 8, shadowRadius: 5, backgroundColor: .clear, opacity: 0.2, size: .zero)
        
        self.descriptionHightConstraint.isActive = false
        showMoreButton.isHidden = true
        self.repoDescriptionTextView.textContainerInset = UIEdgeInsets.zero
        self.repoDescriptionTextView.textContainer.lineFragmentPadding = 0
        self.observeFrame()
    }
    
    func setupWith(viewModel: RepoItemCellViewModel) {
        self.accessibilityLabel = viewModel.repo.fullName
        self.viewModel = viewModel
        repoName.text = viewModel.repo.name
        ownerName.text = viewModel.repo.owner.login
        stars.text = String(viewModel.repo.stargazersCount)
        repoDescriptionTextView.text = viewModel.repo.itemDescription
        
        self.updateExpandedState()
    }

    private func updateExpandedState() {
        guard let vm = viewModel else { return }
        self.descriptionHightConstraint?.isActive = !(vm.needShowMore && vm.expanded)
        self.showMoreButton?.isHidden = !vm.needShowMore
        self.showMoreButton?.setTitle(vm.expanded ?  "Show Less" : "Show More", for: .normal)
    }
    
    private func observeFrame() {
        self.frameObserver = self.observe(\.frame, options: .new) { [weak self] _, _ in
            guard let strongSelf = self,
                  let descriptionTextView = self?.repoDescriptionTextView
                else { return }
            
            strongSelf.setNeedsLayout()
            strongSelf.layoutIfNeeded()
            
            let size = CGSize(width: descriptionTextView.frame.width, height: .infinity)
            let targetSize = descriptionTextView.sizeThatFits(size)
            
            let maxHeight = strongSelf.maxDescriptionHeight
            
            if targetSize.height > maxHeight && strongSelf.viewModel?.needShowMore == false {
                strongSelf.delegate?.updateCellHeight(vm: nil) {
                    strongSelf.viewModel?.needShowMore = true
                    strongSelf.updateExpandedState()
                    strongSelf.needsUpdateConstraints()
                }
            } else if targetSize.height <= maxHeight && strongSelf.viewModel?.needShowMore == true {
                strongSelf.delegate?.updateCellHeight(vm: nil) {
                    strongSelf.viewModel?.needShowMore = false
                    strongSelf.updateExpandedState()
                    strongSelf.needsUpdateConstraints()
                }
            }
        }
        
    }

    @IBAction func showMoreButtonTapped(_ sender: UIButton) {
        guard let viewModel = viewModel else {
            return
        }
        delegate?.updateCellHeight(vm: viewModel, inBlock: {
            viewModel.expanded = !viewModel.expanded
            self.updateExpandedState()
            self.needsUpdateConstraints()
        })
    }
}
