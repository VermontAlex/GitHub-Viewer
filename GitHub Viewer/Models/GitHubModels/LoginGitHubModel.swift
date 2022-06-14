//
//  AuthGitHubModel.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 08.06.2022.
//

import Foundation

struct LoginGitHubModel: Codable {
    
    let grantType: String
    let code: String
    let clientId: String
    let clientSecret: String
    let state: String? = nil
    
    private enum CodingKeys : String, CodingKey {
        case grantType = "grant_type", code = "code", clientId = "client_id", clientSecret = "client_secret", state = "state"
    }
}
