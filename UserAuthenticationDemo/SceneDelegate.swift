//
//  SceneDelegate.swift
//  UserAuthenticationDemo
//
//  Created by Aitor Zubizarreta Perez on 24/01/2021.
//

import UIKit
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        
        // Check local data - Is a user logged in already?
        let localData: Persistence = Persistence()
        if localData.isSessionOpen() {
            // Check
            if let savedUser = localData.getAppleSignIntUserData() {
                ASAuthorizationAppleIDProvider().getCredentialState(forUserID: savedUser.id) { (credentialState, error) in
                    switch credentialState {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.window?.rootViewController = ProfileViewController()
                        }
                    case .revoked:
                        print("User revoked authorization.")
                        DispatchQueue.main.async {
                            localData.deleteOpenSession()
                            localData.deleteAppleSignInUserData()
                            self.window?.rootViewController = LogInViewController()
                        }
                    case .notFound:
                        print("User authorization not found.")
                        DispatchQueue.main.async {
                            localData.deleteOpenSession()
                            localData.deleteAppleSignInUserData()
                            self.window?.rootViewController = LogInViewController()
                        }
                    default:
                        print("Unknow error getting user authorization.")
                        DispatchQueue.main.async {
                            localData.deleteOpenSession()
                            localData.deleteAppleSignInUserData()
                            self.window?.rootViewController = LogInViewController()
                        }
                    }
                }
            }
        } else {
            self.window?.rootViewController = LogInViewController()
        }
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

