//
//  RegisterVC.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 19/10/2021.
//

import UIKit
import SQLite

class RegisterVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerImageView: UIImageView!
    @IBOutlet weak var registerImageViewBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    
    //MARK: -Variable
    var user: User!
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviegationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        loginBtn.layer.cornerRadius = 7.0
        createBtn.layer.cornerRadius = 7.0
        setCornerRadius()
        setPlaceHolder(textField: nameTextField , text: "Enter Your Name")
        setPlaceHolder(textField: emailTextField, text:"Enter Your Email")
        setPlaceHolder(textField: addressTextField, text: "Enter Your Address")
        setPlaceHolder(textField: passwordTextField, text: "Enter Your Password")
    }
    
    //MARK: - Functions
    private func setNaviegationBar(){
        navigationItem.title = "Register"
    }
    
    private func setPlaceHolder(textField: UITextField , text: String){
        textField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)]
        )
    }
    
    private func setCornerRadius(){
        registerImageView.layer.cornerRadius = (registerImageView.frame.size.width  ) / 7
        registerImageView.clipsToBounds = true
        registerImageView.layer.borderWidth = 2.0
        registerImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func isValiedEmail(email: String) -> Bool{
        if !email.trimed.isEmpty{
            if Validtor.shared().isEmailValid(email: email){
                if SqlManager.shared().checkEmailInDB(email: email)!{
                    return true
                }else{
                    showAlert(title: "Sorry", message: "please enter  a different email, this email is taken")
                }
            }
            else{
                showAlert(title: "Sorry", message: "please Enter valid email example khaled@gmail.com")
                return false
            }
            
        }else{
            print("please Check Your Email")
            showAlert(title: "Sorry", message: "please Check Your Email")
        }
        
        return false
    }
    
    private func isValiedPassword(password: String) -> Bool{
        if !password.isEmpty{
            if Validtor.shared().isPasswordValid(password: password){
                return true
            }else{
                showAlert(title: "Sorry", message: "please Enter valid Password with at least a capital letter & one letter smale and at least one number at total 8 number or more")
                return false
            }
        }else{
            showAlert(title: "Sorry", message: "please Check Your Password")
        }
        return false
    }
    
    private func isValiedaddress(address: String) -> Bool{
        if !address.isEmpty{
            return true
        }else{
            showAlert(title: "Sorry", message: "Please Check your Address's Field")
            return false
        }
    }
    
    private func isValiedName(name: String) -> Bool{
        if !name.isEmpty{
            return true
        }else{
            showAlert(title: "Sorry", message: "Please Check your Name's Field")
            return false
        }
    }
    
    private func isEnteredImage(image: UIImage)-> Bool{
        if image == UIImage(systemName: "person.fill"){
            showAlert(title: "Sorry", message: "pls Enter profile image")
            return false
        }else{
            return true
        }
    }
    
    private func isValidedIn()-> Bool{
        if let name = nameTextField.text ,isValiedName(name: name)
            , let email = emailTextField.text ,isValiedEmail(email: email)
            , let password = passwordTextField.text ,isValiedPassword(password: password)
            , let address = addressTextField.text ,isValiedaddress(address: address)
            , let image = registerImageView.image ,isEnteredImage(image: image) {
            return true
        }
        return false
    }
    
    @objc private func goToLogin(){
        let sb = UIStoryboard(name: ViewContollers.main, bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: ViewContollers.loginVC)as! LoginVC
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    //MARK: -Actions
    @IBAction func createBtnTapped(_ sender: UIButton) {
        if isValidedIn() {
            SqlManager.shared().insertUser(name: nameTextField.text!, email: emailTextField.text!, address: addressTextField.text!, password: passwordTextField.text!, imageView: registerImageView)
            SuccessAlert(message: "Your Account Created Succesfully") { _ in
                self.goToLogin()
            }
        }
    }
    @IBAction func LoginBtnTapped(_ sender: UIButton) {
        goToLogin()
    }
    @IBAction func MapBtnTapped(_ sender: UIButton) {
        let sb = UIStoryboard(name: ViewContollers.main, bundle: nil)
        let mapVC = sb.instantiateViewController(withIdentifier: ViewContollers.mapVC)as! MapVC
        self.present(mapVC, animated: true, completion: nil)
        mapVC.delegate = self
    }
    @IBAction func ImageBtnTapped(_ sender: UIButton) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        self.present(imagePickerVC, animated: true, completion: nil)
    }
}
//MARK: -Extension
extension RegisterVC: setLocationDelegation{
    func Address(message: String) {
        addressTextField.text = message
    }
}

extension RegisterVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            registerImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
}

