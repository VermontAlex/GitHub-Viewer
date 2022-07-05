//
//  TouchedView.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 05.07.2022.
//

import UIKit

class TouchedView: UIView {
    
    var resignView: (() -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
        if let completion = resignView {
            completion()
        }
    }
}
