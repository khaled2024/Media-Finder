//
//  AppDelegate.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 19/10/2021.
//

import UIKit
import IQKeyboardManagerSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // keyboard touch out side
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        // for sqlManager
        SqlManager.shared().setUpAllConnections()
        SqlManager.shared().CreateAllTables()
        // root
        setRoot()
        return true
    }
    //MARK: - functions
    func setRoot(){
        let def = UserDefaults.standard
        if let isLoggedIn = def.object(forKey: UserDefultsKeys.isLoggedIn)as? Bool{
            if isLoggedIn {
                goTOMoviesScreen()
            }else {
                goTOLoginScreen()
            }
        }
    }
    func goTOMoviesScreen(){
        let sb = UIStoryboard(name: ViewContollers.main, bundle: nil)
        let moviesVC = sb.instantiateViewController(withIdentifier: ViewContollers.moviesVC)as! MoviesVC
        let navController = UINavigationController(rootViewController: moviesVC)
        self.window?.rootViewController = navController
    }
    func goTOLoginScreen(){
        let sb = UIStoryboard(name: ViewContollers.main, bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: ViewContollers.loginVC)as! LoginVC
        let navController = UINavigationController(rootViewController: loginVC)
        self.window?.rootViewController = navController
    }
    // other function
    func goTOProfileScreen(){
        let sb = UIStoryboard(name: ViewContollers.main, bundle: nil)
        let profileVC = sb.instantiateViewController(withIdentifier: ViewContollers.profileVC)as! ProfileVC
        self.window?.rootViewController = profileVC
    }
}

