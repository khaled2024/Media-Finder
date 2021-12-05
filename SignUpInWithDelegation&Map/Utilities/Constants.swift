//
//  Constants.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 28/10/2021.
//

import Foundation

struct ViewContollers {
    static let main = "Main"
    static let registerVC = "RegisterVC"
    static let loginVC = "LoginVC"
    static let mapVC = "MapVC"
    static let moviesVC = "MoviesVC"
    static let profileVC = "ProfileVC"
}
struct Cells {
    static let movieCell = "MovieCell"
}
struct UserDefultsKeys{
    static let isLoggedIn = "isLoggedIn"
    static let email = "email"
    static let user = "user"
}
struct SetUpConnection{
    static let users = "users"
    static let media = "media"
}
struct TabelsNames{
    static let usersTable = "Users"
    static let mediaTable = "Usersmedia"
}
enum ResultSegment: String {
    case all = "all"
    case music = "music"
    case tvShow = "tvShow"
    case movie = "movie"
}
