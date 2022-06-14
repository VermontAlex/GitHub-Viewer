//
//  APIManager.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 07.06.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func getAccessTokenWithBody(responseCode: String, authGHModel: LoginGitHubModel, completion: @escaping (Result<GitHubTokenModel, Error>) -> Void)
}

struct GitHubNetworkManager: NetworkManagerProtocol {
    
    func getAccessTokenWithBody(responseCode: String, authGHModel: LoginGitHubModel,
                                completion: @escaping (Result<GitHubTokenModel, Error>) -> Void) {
        guard let request = GitHubRequestBuilder.getAccessTokenRequest(authGHModel).requestToken else { return }
        
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(GitHubTokenModel.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
}


/*
func fetchGitHubUserProfile(accessToken: String) {
        let tokenURLFull = "https://api.github.com/user"
        let verify: NSURL = NSURL(string: tokenURLFull)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
            if error == nil {
                let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                // AccessToken
                print("GitHub Access Token: \(accessToken)")
                // GitHub Handle
                let githubId: Int! = (result?["id"] as! Int)
                print("GitHub Id: \(githubId ?? 0)")
                // GitHub Display Name
                let githubDisplayName: String! = (result?["login"] as! String)
                print("GitHub Display Name: \(githubDisplayName ?? "")")
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
*/
