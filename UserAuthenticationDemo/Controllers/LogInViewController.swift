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
    
    ///
    /// Saves open session locally.
    ///
    private func saveOpenSession() {
        let localData: Persistence = Persistence()
        localData.saveOpenSession()
    }
    
    ///
    /// Saves users data locally.
    ///
    private func saveDataLocally(identifier: String, fullName: String, email: String) {
        // Save data locally.
        let localData: Persistence = Persistence()
        localData.saveAppleSignInUserData(id: identifier, fullName: fullName, email: email)
    }
    
    ///
    /// Gets user data.
    ///
    private func getUserLocalData() -> User? {
        let localData: Persistence = Persistence()
        return localData.getAppleSignIntUserData()
    }
    
    ///
    /// Go to ProfileViewController.
    ///
    private func goToProfile(identifier: String, fullName: String, email: String) {
        // Creates the ViewController.
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        
        // Displays the ViewController.
        let rootVC = UIApplication.shared.windows.first { $0.isKeyWindow }
        rootVC?.rootViewController = profileVC
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
            
            // Identifier.
            let userIdentifier: String = appleIDCredentials.user
            
            // Full Name.
            var fullName: String = ""
            if let receivedName = appleIDCredentials.fullName?.givenName {
                fullName = receivedName
            }
            if let receivedSurname = appleIDCredentials.fullName?.familyName {
                if fullName == "" {
                    fullName = receivedSurname
                } else {
                    fullName = fullName + " \(receivedSurname)"
                }
            }
            if let receivedNickname = appleIDCredentials.fullName?.nickname {
                if fullName == "" {
                    fullName = receivedNickname
                } else {
                    fullName = fullName + " (\(receivedNickname)"
                }
            }
            
            // Email.
            let email: String = appleIDCredentials.email ?? ""
            
            // Check if there is already a user saved locally.
            if let _ = self.getUserLocalData() {
                print("There is a user Log In.")
            } else {
                self.saveDataLocally(identifier: userIdentifier, fullName: fullName, email: email)
            }
            
            self.saveOpenSession()
            self.goToProfile(identifier: userIdentifier, fullName: fullName, email: email)
        }
    }
    
    ///
    /// Apple Sign-In Completed with Errors.
    ///
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign-In Error : \(error.localizedDescription)")
        
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        switch error.code {
        case .canceled:
            print("User press cancel button")
        case .unknown:
            print("Unknow error")
        case .invalidResponse:
            print("Invalid response")
        case .notHandled:
            print("Not handlet, maybe comunication error.")
        case .failed:
            print("Failed")
        default:
            print("Defaul")
        }
    }
}
