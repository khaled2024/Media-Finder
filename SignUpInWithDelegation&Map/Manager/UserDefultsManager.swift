//
//  UserDefultsManager.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 28/10/2021.
//

import Foundation
import Metal
class UserDefultsManager{
    //MARK: - Signleton
    private static let sharedInstance = UserDefultsManager()
    static func shared() ->UserDefultsManager{
        return UserDefultsManager.sharedInstance
    }
    //MARK: - variabels
    
    private let def = UserDefaults.standard
    var email: String{
        set{
            def.set(newValue, forKey: UserDefultsKeys.email)
        }
        get{
            guard def.object(forKey: UserDefultsKeys.email) != nil else  {
                return "Nothing"
            }
            return def.string(forKey: UserDefultsKeys.email)!
        }
    }
    
    var isLoggedIn: Bool{
        set{
            def.set(newValue, forKey: UserDefultsKeys.isLoggedIn)
        }
        get{
            guard def.object(forKey: UserDefultsKeys.isLoggedIn) != nil else  {
                return false
            }
            return def.bool(forKey: UserDefultsKeys.isLoggedIn)
        }
    }
}
