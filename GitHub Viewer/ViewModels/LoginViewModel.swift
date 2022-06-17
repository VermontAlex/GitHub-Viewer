//
//  LoginViewModel.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

struct LoginViewModel {
    
    let title: String = "Please signIn with GitHub Account."
    let titleConnection = "Network connection isn't available, please switch it on or try again later."
    var isAbleConnection: Bool {
        get {
            InternetReachability.isConnectedToNetwork()
        }
    }
}
