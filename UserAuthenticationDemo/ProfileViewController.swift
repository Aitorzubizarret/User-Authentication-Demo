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
    
    // MARK: Properties
    
    var userIdentidier: String = ""
    var userFullName: String = ""
    var userEmail: String = ""
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
}
