//
//  APIManager.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 07.06.2022.
//

import Foundation

struct GitHubNetworkManager {
    
    func gitHubSignIn(responseCode: String, authGHModel: LoginGitHubModel,
                      completion: @escaping (Result<GHUserProfileModel, Error>) -> Void) {
        guard let request = GitHubRequestBuilder.getAccessTokenRequest(authGHModel).request else { return }
        
        let operationQueue = OperationQueue()
        var accessToken: GitHubTokenModel?
        
        let tokenOperation = FetchToken(urlRequest: request) { result in
            switch result {
            case .success(let token):
                accessToken = token
            case . failure(let error):
                completion(.failure(error))
            }
        }
        
        tokenOperation.completionBlock = {
            guard let token = accessToken,
                  let request = GitHubRequestBuilder.getUserProfile(accessToken: token).request
            else { return }
            
            let profileOperation = FetchProfile(urlRequest: request, completion: completion)
            operationQueue.addOperation(profileOperation)
        }
        
        operationQueue.addOperation(tokenOperation)
        
        operationQueue.waitUntilAllOperationsAreFinished()
    }
}

private final class FetchToken: BasicSequenceOperation {
    
    init(urlRequest: URLRequest,
         completion: @escaping (Result<GitHubTokenModel, Error>) -> Void) {
        super.init()
        task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self] (data, response, error) in
            if let data = data {
                do {
                    let token = try JSONDecoder().decode(GitHubTokenModel.self, from: data)
                        completion(.success(token))
                        self?.state = .finished
                } catch {
                        completion(.failure(error))
                        self?.state = .finished
                }
            } else if let error = error {
                    completion(.failure(error))
                    self?.state = .finished
            }
            self?.state = .finished
        })
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        
        state = .executing
        
        self.task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        self.task?.cancel()
    }
}

private final class FetchProfile: BasicSequenceOperation {
    
    init(urlRequest: URLRequest,
         completion: @escaping (Result<GHUserProfileModel, Error>) -> Void) {
        super.init()
        task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self] (data, response, error) in
            if let data = data {
                do {
                    let profile = try JSONDecoder().decode(GHUserProfileModel.self, from: data)
                        completion(.success(profile))
                        self?.state = .finished
                } catch {
                        completion(.failure(error))
                        self?.state = .finished
                }
            } else if let error = error {
                    completion(.failure(error))
                    self?.state = .finished
            }
            self?.state = .finished
        })
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        
        state = .executing
        
        self.task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        self.task?.cancel()
    }
}
