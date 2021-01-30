//
//  ProfileViewController.swift
//  UserAuthenticationDemo
//
//  Created by Aitor Zubizarreta Perez on 25/01/2021.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: UI Elements
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var userIdentifierLabel: UILabel!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBAction func signOutButtonPressed(_ sender: Any) {
        self.signOut()
    }
    
    // MARK: Properties
    
    var user: User?
    var userIdentidier: String = ""
    var userFullName: String = ""
    var userEmail: String = ""
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Local Data.
        let localData: Persistence = Persistence()
        self.user = localData.getAppleSignIntUserData()
        self.userIdentidier = self.user?.id ?? ""
        self.userFullName = self.user?.name ?? ""
        self.userEmail = self.user?.email ?? ""
        
        self.configureUI()
    }

    ///
    /// Configures the UI Elements.
    ///
    private func configureUI() {
        self.mainTitleLabel.text = "Profile"
        self.userIdentifierLabel.text = "ID: \(self.userIdentidier)"
        self.userFullNameLabel.text = "Name: \(self.userFullName)"
        self.userEmailLabel.text = "Email: \(self.userEmail)"
        self.signOutButton.setTitle("Sign Out", for: .normal)
    }
    
    ///
    /// Signs Out and goes back to Login screen.
    ///
    private func signOut() {
        // Sign out.
        let localData: Persistence = Persistence()
        localData.deleteOpenSession()
        
        // Creates the ViewController.
        let loginVC = LogInViewController(nibName: "LogInViewController", bundle: nil)
        
        // Displays the ViewController.
        let rootVC = UIApplication.shared.windows.first { $0.isKeyWindow }
        rootVC?.rootViewController = loginVC
    }
}
