//
//  SqlManager.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 21/11/2021.
//

import UIKit
import SQLite

class SqlManager {
    //MARK: - Signleton
    private static let sharedInstance = SqlManager()
    static func shared() ->SqlManager{
        return SqlManager.sharedInstance
    }
    //MARK: - variables
    var database: Connection!
    private let usersTable = Table(TabelsNames.usersTable)
    private let id = Expression<Int>("id")
    private let name = Expression<String>("name")
    private let email = Expression<String>("email")
    private let password = Expression<String>("password")
    private let address = Expression<String>("address")
    private let image = Expression<Data>("image")
    // media table
    private let mediaTable = Table(TabelsNames.mediaTable)
    private let emailData = Expression<String>("emailData")
    private let mediaHistoryData = Expression<Data>("mediaHistoryData")
    private let mediaTypeData = Expression<String>("mediaTypeData")
    
    //MARK: - functions
    func setUpAllConnections(){
        setUpUsersConnection(user: SetUpConnection.users)
        setUpMediaConnection(media: SetUpConnection.media)
    }
    func CreateAllTables(){
        self.createTableForUser()
        self.createMediaTable()
    }
    
    private func setUpUsersConnection(user: String){
        do{
            let doc = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = doc.appendingPathComponent(user).appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }catch{
            print(error)
        }
    }
    
    private func setUpMediaConnection(media: String){
        do{
            let doc = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = doc.appendingPathComponent(media).appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }catch{
            print(error)
        }
    }
    
    private func createTableForUser(){
        let createTable = self.usersTable.create{ table in
            table.column(self.id , primaryKey: true)
            table.column(self.name)
            table.column(self.email, unique: true)
            table.column(self.password)
            table.column(self.address)
            table.column(self.image)
        }
        do {
            try  database.run(createTable)
            print("The table is created")
        } catch  {
            print(error)
        }
    }
    
    private func createMediaTable(){
        let createTable = self.mediaTable.create{ table in
            table.column(self.id, primaryKey: true)
            table.column(self.emailData)
            table.column(self.mediaHistoryData)
            table.column(self.mediaTypeData)
        }
        do {
            try  database.run(createTable)
            print("The table is created")
        } catch  {
            print(error)
        }
    }
    
    //database functions (users)
    func insertUser(name: String, email: String, address: String, password: String, imageView: UIImageView){
        if !name.isEmpty ,  !email.isEmpty  , !address.isEmpty , !password.isEmpty , let image = imageView.image , let photo = image.jpegData(compressionQuality: 1) {
            let insertUser = self.usersTable.insert(self.name <- name , self.email <- email ,self.address <- address , self.password <- password , self.image <- photo)
            do {
                try self.database.run(insertUser)
                print("The user is inserted")
            } catch  {
                print(error)
            }
        }
    }
    
    func getAllUsers(){
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users{
                print("userID:\(user[self.id]), Name:\(user[self.name]), Email:\(user[self.email]) , Address:\(user[self.address]) , password:\(user[self.password]) , image:\(user[self.image])")
            }
        } catch  {
            print(error)
        }
    }
    
    func getUserFromDB(emailUser: String)-> User?{
        do {
            let query = self.usersTable.filter( self.email == emailUser)
            let users = try self.database.prepare(query)
            for user in users{
                let user = User(name: user[name], email: user[email], password: user[password], address: user[address], image: user[image])
                return user
            }
        } catch  {
            print(error)
        }
        return nil
    }
    
    func loginAuth(email: String , password: String)-> Bool{
        do {
            let users = try database.prepare(usersTable)
            for user in users{
                if !email.isEmpty, email == user[self.email] ,
                   !password.isEmpty, password == user[self.password] {
                    return true
                }
            }
        }catch{
            print(error)
        }
        return false
    }
    
    //database functions (media)
    func insertMedia(email: String , mediaData: Data , type: String){
        //        deleteMediaTable()
        let email = UserDefultsManager.shared().email
        let insertMedia = self.mediaTable.insert(self.emailData <- email ,
                                                 self.mediaHistoryData <- mediaData ,
                                                 self.mediaTypeData <- type
        )
        do{
            try self.database.run(insertMedia)
        }catch{
            print(error)
        }
    }
    
    func deleteMediaTable(){
        do{
            if try database.run(mediaTable.delete()) > 0 {
            }else{
            }
        }catch{
            print(error)
        }
    }
    
    func getAllMedia(){
        do {
            let mediaData = try self.database.prepare(self.mediaTable)
            for media in mediaData{
                print("ID:\(media[self.id]), emailData:\(media[self.emailData]), mediaHistoryData:\(media[self.mediaHistoryData]) , mediaTypeData:\(media[self.mediaTypeData])")
            }
        } catch  {
            print(error)
        }
    }
    
    func getMedia(email: String) -> (Data , String)?{
        var data: Data?
        var type: String = ""
        do{
            let mediaData = try self.database.prepare(self.mediaTable)
            for media in mediaData{
                if email == media[self.emailData]{
                    data = media[self.mediaHistoryData]
                    type = media[self.mediaTypeData]
                }
            }
        }catch{
            print(error)
        }
        return (data , type) as? (Data, String)
    }
    
}
