//
//  StoryboardedProtocol.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit

protocol StoryboardedProtocol {
    static func instantiateCustom(storyboard: String) -> Self
}

extension StoryboardedProtocol where Self: UIViewController {
    static func instantiateCustom(storyboard: String) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
