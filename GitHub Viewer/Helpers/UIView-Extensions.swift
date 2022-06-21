//
//  UIView-Extensions.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 17.06.2022.
//

import UIKit

public extension UIView {
    
    class var className: String {
        let stringClassName = NSStringFromClass(self)
        guard let range = stringClassName.range(of: ".") else { return "" }
        
        return String(stringClassName[range.upperBound...])
    }
    
    class func nib() -> UINib {
        return UINib(nibName: className, bundle: Bundle(for: self))
    }
    
    func addEdgeConstrainsToSuperview(insets: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
