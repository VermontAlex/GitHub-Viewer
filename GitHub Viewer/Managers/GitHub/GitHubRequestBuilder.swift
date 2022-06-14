//
//  APIType.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 07.06.2022.
//

import Foundation

enum GitHubRequestBuilder {
    
    case getAccessTokenRequest(LoginGitHubModel)
    case getAuthRequest(cliendId: String)
    
    private var baseUrl: String {
        return "https://github.com/"
    }
    
    private var path: String {
        switch self {
        case .getAccessTokenRequest:
             return "/login/oauth/access_token"
        case .getAuthRequest:
            return "/login/oauth/authorize"
        }
    }
    
    var requestAuth: URLRequest? {
        switch self {
        case .getAuthRequest(let cliendId):
            guard let url = formSignInUrl(cliendId: cliendId) else { return nil }
            return URLRequest(url: url)
        default:
            return nil
        }
    }
    
    var requestToken: URLRequest? {
        switch self {
        case .getAccessTokenRequest(let authGHModel):
            guard let url = URL(string: path, relativeTo: URL(string: baseUrl)) else { return nil }
            let httpBody = try? JSONEncoder().encode(authGHModel)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = httpBody
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        default:
            return nil
        }
    }

    private func formSignInUrl(cliendId: String) -> URL? {
        guard let url = URL(string: baseUrl) else { return nil }
        var components = URLComponents()
        var queryItems = [URLQueryItem]()
        components.scheme = url.scheme
        components.host = url.host
        components.path = path
        
        queryItems.append(URLQueryItem(name: "client_id", value: cliendId))
        queryItems.append(URLQueryItem(name: "state", value: UUID().uuidString))
        
        components.queryItems = queryItems
        
        return components.url
    }
}
