//
//  Validtor.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 28/10/2021.
//

import Foundation
import UIKit

class Validtor: UIViewController{
    //MARK: - Signleton
    static func shared() ->Validtor{
        return Validtor.sharedInstance
    }
    private static let sharedInstance = Validtor()
    
    //MARK: - functions
    
    func isEmailValid(email: String)->Bool{
        let regx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regx)
        return pred.evaluate(with: email)
    }
    func isPasswordValid(password: String)->Bool{
        let regx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regx)
        return pred.evaluate(with: password)
    }
}

