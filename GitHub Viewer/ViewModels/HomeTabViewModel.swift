//
//  HomePageViewModel.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 15.06.2022.
//

struct HomeTabViewModel {
    
    let account: AccountViewModelProtocol
    let service: String
    var tokenToUse: String? {
        get {
            return retreiveToken()
        }
    }
    
    init(account: AccountViewModelProtocol, server: String) {
        self.account = account
        self.service = server
    }
    
    private func retreiveToken() -> String? {
        do {
            let result = try KeyChainManager.get(account: account.login, service: service)
            return String(data: result, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }
}
