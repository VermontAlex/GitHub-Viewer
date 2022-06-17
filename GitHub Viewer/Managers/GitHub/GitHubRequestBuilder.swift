//
//  APIType.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 07.06.2022.
//

import Foundation

enum GitHubRequestBuilder {
    
    case getAccessTokenRequest(responseCode: String)
    case getAuthRequest(cliendId: String)
    case getUserProfile(accessToken: GitHubTokenModel)
    
    private var baseUrl: String {
        return "https://github.com/"
    }
    
    private var apiGHUrl: String {
        return "https://api.github.com"
    }
    
    private var path: String {
        switch self {
        case .getAccessTokenRequest:
             return "/login/oauth/access_token"
        case .getAuthRequest:
            return "/login/oauth/authorize"
        case .getUserProfile:
            return "/user"
        }
    }
    
    var request: URLRequest? {
        switch self {
        case .getAuthRequest(let cliendId):
            guard let url = formSignInUrl(cliendId: cliendId) else { return nil }
            return URLRequest(url: url)
        case .getAccessTokenRequest(let responseCode):
            guard let url = URL(string: path, relativeTo: URL(string: baseUrl)) else { return nil }
            let httpBody = try? JSONEncoder().encode(LoginGitHubModel(code: responseCode))
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = httpBody
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        case .getUserProfile(let token):
            guard let url = URL(string: path, relativeTo: URL(string: apiGHUrl)) else { return nil }
            var request = URLRequest(url: url)
            request.addValue(token.tokenType + " " + token.accessToken, forHTTPHeaderField: "Authorization")
            
            return request
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
