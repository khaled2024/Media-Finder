//
//  Networking.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 30/11/2021.
//

import Alamofire

class ApiManager{
    static func loadMediaArr(term: String, media: String, completion: @escaping (_ error: Error? , _ mediaArr: [Media]?) -> Void){
        let parameter = ["term" : term , "media" : media]
        AF.request("https://itunes.apple.com/search", method: .get, parameters: parameter, encoding: URLEncoding.default , headers: nil).response {
            response in
            if let error = response.error {
                completion(error , nil)
            }
            if let data = response.data {
                do{
                    let mediaArr = try JSONDecoder().decode(MediaResponse.self, from: data).results
                    completion(nil,mediaArr)
                } catch let error {
                    completion(error , nil)
                }
            }
        }
    }
    
}
