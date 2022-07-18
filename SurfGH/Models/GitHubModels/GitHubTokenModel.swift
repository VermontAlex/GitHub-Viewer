//
//  GitHubTokenModel.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 08.06.2022.
//

import Foundation

struct GitHubTokenModel: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
}
