//
//  ProfileVC.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 19/10/2021.
//

import UIKit
import SQLite

class ProfileVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var emailLable: UILabel!
    @IBOutlet weak var AddressLable: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    //MARK: Variable
    var user: User!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUserDate()
        setNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpLayouts()
    }
    
    //MARK: Functions
    private func setUpLayouts(){
        profileImageView.layer.cornerRadius = (profileImageView.frame.size.width  ) / 7
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setUserDate(){
        usernameLable.text = "Name: " + user.name
        emailLable.text =  "Email: " + user.email
        AddressLable.text = "Address: " + user.address
        let image = UIImage(data: user.image)
        profileImageView.image = image
        
    }
    
    private func setUp(){
        let email = UserDefultsManager.shared().email
        user = SqlManager.shared().getUserFromDB(emailUser: email)!
    }
    
    private func setNavigationBar(){
        navigationItem.title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(goToLogin))
        
    }
    @objc private func goToLogin(){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            appDelegate.goTOLoginScreen()
        }
        showAlert(title: "", message: "You logged out Successfully")
    }
}
