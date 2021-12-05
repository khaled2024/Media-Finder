//
//  LoginVC.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 19/10/2021.
//

import UIKit
import SQLite

class LoginVC: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    
    //MARK: Variable
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: UserDefultsKeys.isLoggedIn)
        SqlManager.shared().getAllUsers()
    }
    override func viewWillAppear(_ animated: Bool) {
        LoginBtn.layer.cornerRadius = 7.0
        LoginBtn.layer.cornerRadius = 7.0
        setPlaceHolder(textField: EmailTextField, text: "Enter Your Email")
        setPlaceHolder(textField: PasswordTextField, text: "Enter Your Password")
    }
    
    //MARK: Functions
    private func setPlaceHolder(textField: UITextField , text: String){
        textField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)]
        )
    }
    
    private func loginValidation(){
        if let email = EmailTextField.text , !email.isEmpty ,let password = PasswordTextField.text ,!password.isEmpty{
            let loginAuth = SqlManager.shared().loginAuth(email: EmailTextField.text!, password: PasswordTextField.text!)
            if loginAuth {
                let email = EmailTextField.text!
                UserDefaults.standard.set(email, forKey: UserDefultsKeys.email)
                // UserDefultsManager.shared().email = EmailTextField.text!
                goToMovies()
            }else{
                showAlert(title: "Sorry", message: "Your Email or Password are Incorrect")
            }
        }
        else {
            showAlert(title: "Sorry", message: "Please Check your Fields")
        }
    }
    
    private func goToMovies(){
        let sb = UIStoryboard(name: ViewContollers.main, bundle: nil)
        let moviesVC = sb.instantiateViewController(withIdentifier: ViewContollers.moviesVC)as! MoviesVC
        navigationController?.pushViewController(moviesVC, animated: true)
    }
    
    //MARK: Actions
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        loginValidation()
    }
    @IBAction func createAccountBtnTapped(_ sender: UIButton) {
        let sb = UIStoryboard(name: ViewContollers.main, bundle: nil)
        let registerVC = sb.instantiateViewController(withIdentifier: ViewContollers.registerVC)as! RegisterVC
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
