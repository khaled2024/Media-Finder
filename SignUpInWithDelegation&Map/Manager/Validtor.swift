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
        let regx = Regxs.emailregx
        let pred = NSPredicate(format: Regxs.predicateFormate, regx)
        return pred.evaluate(with: email)
    }
    func isPasswordValid(password: String)->Bool{
        let regx = Regxs.passwordregx
        let pred = NSPredicate(format: Regxs.predicateFormate, regx)
        return pred.evaluate(with: password)
    }
}

