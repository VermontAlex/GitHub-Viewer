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
    @IBOutlet var infoContainerStackView: UIStackView!
    
    
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
        frameObserver?.invalidate()
        observeFrame()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .white 
        mainView?.layer.borderColor = UIColor.gray.cgColor
        mainView?.layer.borderWidth = 0.3
        mainView.backgroundColor = .systemBackground
        mainView?.dropShadow(cornerRadius: 8, shadowRadius: 5, backgroundColor: .clear, opacity: 10,
                                  size: .zero)
        
        descriptionHightConstraint.isActive = false
        showMoreButton.isHidden = true
        repoDescriptionTextView.textContainerInset = UIEdgeInsets.zero
        repoDescriptionTextView.textContainer.lineFragmentPadding = 0
        observeFrame()
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
        descriptionHightConstraint?.isActive = !(vm.needShowMore && vm.expanded)
        showMoreButton?.isHidden = !vm.needShowMore
        showMoreButton?.setTitle(vm.expanded ?  "Show Less" : "Show More", for: .normal)
    }
    
    private func observeFrame() {
        DispatchQueue.global().async {
            self.frameObserver = self.observe(\.frame, options: .new) { [weak self] _, _ in
                DispatchQueue.main.async {
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
