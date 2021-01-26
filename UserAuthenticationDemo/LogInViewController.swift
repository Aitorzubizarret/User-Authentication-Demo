//
//  ViewController.swift
//  UserAuthenticationDemo
//
//  Created by Aitor Zubizarreta Perez on 24/01/2021.
//

import UIKit
import AuthenticationServices

class LogInViewController: UIViewController {

    // MARK: UI Elements
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var AppleSignInButtonView: UIView!
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.configureUI()
        self.addAppleSignIn()
    }
    
    ///
    /// Configures the UI Elements.
    ///
    private func configureUI() {
        self.mainTitleLabel.text = "Log In"
    }
    
    ///
    /// Adds the official Apple Sign-In button in the view.
    ///
    private func addAppleSignIn() {
        let AppleSignInButton = ASAuthorizationAppleIDButton()
        AppleSignInButton.addTarget(self, action: #selector(self.registerWithApple), for: .touchUpInside)
        self.AppleSignInButtonView.addSubview(AppleSignInButton)
    }
    
    ///
    /// Configures the Apple Sign-In Authentication Service.
    ///
    @objc func registerWithApple() {
        let appleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
        appleIDRequest.requestedScopes = [.fullName, .email]
        
        let requests = [appleIDRequest]
        
        let authController = ASAuthorizationController(authorizationRequests: requests)
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
}

///
/// MARK : Apple Sign-In Auth Service Delegate and Context Provider
///
extension LogInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    ///
    /// Apple Sign-In Completed with Success.
    ///
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        // Check the received authorization.
        if let appleIDCredentials = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier: String = appleIDCredentials.user
            let fullName: String = appleIDCredentials.fullName?.description ?? ""
            let email: String = appleIDCredentials.email ?? ""
            
            // Creates the ViewController.
            let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            profileVC.userIdentidier = "\(userIdentifier)"
            profileVC.userFullName = "\(fullName)"
            profileVC.userEmail = "\(email)"
            
            // Displays the ViewController.
            let rootVC = UIApplication.shared.windows.first { $0.isKeyWindow }
            rootVC?.rootViewController = profileVC
        }
        
    }
    
    ///
    /// Apple Sign-In Completed with Errors.
    ///
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign-In Error : \(error.localizedDescription)")
    }
}
