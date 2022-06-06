//
//  LoginViewModel.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

protocol LoginViewModelProtocol {
    var title: String { get set }
}

struct LoginViewModel: LoginViewModelProtocol {
    var title: String
}
