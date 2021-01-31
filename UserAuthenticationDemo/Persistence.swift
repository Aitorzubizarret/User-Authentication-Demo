//
//  Persistence.swift
//  UserAuthenticationDemo
//
//  Created by Aitor Zubizarreta Perez on 29/01/2021.
//

import Foundation

struct Persistence {
    
    enum Keys: String {
        case openSession = "OpenSession"
        case appleSignInUserData = "AppleSignInUserData"
    }
    
    let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
    }
    
    ///
    /// Saves openSession as true to let the app know that there is a logged user.
    ///
    func saveOpenSession() {
        self.userDefaults.set(true, forKey: Keys.openSession.rawValue)
    }
    
    ///
    /// Deletes the openSession value to let the app know that there is not a logged user anymore.
    ///
    func deleteOpenSession() {
        self.userDefaults.removeObject(forKey: Keys.openSession.rawValue)
    }
    
    ///
    /// Checks whether there is an open session or not.
    ///
    func isSessionOpen() -> Bool {
        return self.userDefaults.bool(forKey: Keys.openSession.rawValue)
    }
    
    ///
    /// Saves the data of the user received by Apple Sign In / Authentication Service.
    ///
    func saveAppleSignInUserData(id: String, fullName: String, email: String) {
        let userDataDict = ["id": "\(id)", "fullName": "\(fullName)", "email": "\(email)"]
        self.userDefaults.set(userDataDict, forKey: Keys.appleSignInUserData.rawValue)
    }
    
    ///
    /// Deletes locally saved user data.
    ///
    func deleteAppleSignInUserData() {
        self.userDefaults.removeObject(forKey: Keys.appleSignInUserData.rawValue)
    }
    
    ///
    /// Get locally saved User data obtained from Apple Sign In / Authentication service.
    ///
    func getAppleSignInUserData() -> User?{
        var user: User?
        let localData: [String: String]? = self.userDefaults.object(forKey: Keys.appleSignInUserData.rawValue) as? [String: String]
        
        if let data = localData {
            user = User(id: data["id"] ?? "", name: data["fullName"] ?? "", email: data["email"] ?? "")
        }
        
        return user
    }
}
