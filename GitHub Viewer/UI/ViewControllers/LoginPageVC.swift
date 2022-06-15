//
//  LoginPageVC.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 06.06.2022.
//

import UIKit
import WebKit

class LoginPageVC: UIViewController, StoryboardedProtocol {
    
    @IBOutlet var loginPageTitle: UILabel!
    
    static let identifier = "LoginPageVC"
    static let storyboardName = "LoginPage"
    
    weak var coordinator: CoordinatorProtocol?
    var viewModel: LoginViewModel?
    var gitApiManager: GitHubNetworkManager?
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInformation()
    }
    
    private func fillInformation() {
        guard self.viewModel != nil else { return }
        self.loginPageTitle.text = viewModel?.title
    }
    
    @IBAction func loginWithGitHub(_ sender: Any) {
        startAuthWebViewProcedure()
    }
    
    func startAuthWebViewProcedure() {
        //  Захендлить ошибку
        guard let authRequest = GitHubRequestBuilder.getAuthRequest(cliendId: AuthConstants.cliendIdGH).request else { return }
        let githubVC = UIViewController()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        githubVC.view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: githubVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: githubVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: githubVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: githubVC.view.trailingAnchor)
        ])

        webView.load(authRequest)
        
        showAuthWebView(gitHubWebView: githubVC)
    }
    
    private func showAuthWebView(gitHubWebView: UIViewController) {
        let navController = UINavigationController(rootViewController: gitHubWebView)
        navController.navigationBar.tintColor = UIColor.black
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .systemGray6
    
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        gitHubWebView.navigationItem.leftBarButtonItem = cancelButton
        gitHubWebView.navigationItem.rightBarButtonItem = refreshButton
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navController.navigationBar.titleTextAttributes = textAttributes
        gitHubWebView.navigationItem.title = "github.com"

        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func refreshAction() {
        self.webView.reload()
    }
}

extension LoginPageVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        if let responseUrl = checkAuthResult(request: navigationAction.request) {
            guard let code = parseGitHubSignInResponse(url: responseUrl) else { return }
            
            let loginModel = LoginGitHubModel(grantType: AuthConstants.grantType,
                                              code: code,
                                              clientId: AuthConstants.cliendIdGH,
                                              clientSecret: AuthConstants.clientSecretGH)
            
            gitApiManager?.gitHubSignIn(responseCode: code, authGHModel: loginModel, completion: { result in
                switch result {
                case .success(let profile):
                    print(profile.login)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func checkAuthResult(request: URLRequest) -> String? {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.contains("code=") {
            return requestURLString
        }
        return nil
    }
    
    private func parseGitHubSignInResponse(url: String) -> String? {
        if let range = url.range(of: "=") {
            let githubCode = url[range.upperBound...]
            if let range = githubCode.range(of: "&state=") {
                let result = String(githubCode[..<range.lowerBound])
                return result
            }
        }
        return nil
    }
}
