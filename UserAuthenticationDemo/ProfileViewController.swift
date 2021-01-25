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
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
    }

    private func configureUI() {
        self.mainTitleLabel.text = "Profile"
    }
}
