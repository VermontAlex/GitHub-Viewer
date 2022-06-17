//
//  HomePageViewModel.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 15.06.2022.
//

import UIKit

struct HomeTabViewModel {
    
    let account: AccountViewModelProtocol
    let service: String
    var customTransition: UIViewControllerTransitioningDelegate?
    
    var tokenToUse: String? {
        get {
            return retreiveToken()
        }
    }
    
    init(account: AccountViewModelProtocol, server: String, customTransition: UIViewControllerTransitioningDelegate?) {
        self.account = account
        self.service = server
        self.customTransition = customTransition
    }
    
    private func retreiveToken() -> String? {
        do {
            let result = try KeyChainManager.get(account: account.login, service: service)
            return String(data: result, encoding: String.Encoding.utf8)
        } catch(let keyError) {
            return keyError.localizedDescription
        }
    }
}
