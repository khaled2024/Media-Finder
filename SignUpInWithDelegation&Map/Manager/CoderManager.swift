//
//  CoderManager.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 30/11/2021.
//

import UIKit

class CoderManager{
    //MARK: - Signleton
    private static let sharedInstance = CoderManager()
    static func shared() -> CoderManager{
        return CoderManager.sharedInstance
    }
    
    //MARK: - Variables
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    //MARK: - functions
    func encodeMedia(media: [Media]) -> Data?{
        if let encoded = try? encoder.encode(media){
            return encoded
        }
        return nil
    }
    
    func decodeMedia(mediaData: Data) -> [Media]?{
        if let lodedUser = try? decoder.decode([Media].self, from: mediaData){
            return lodedUser
        }
        return nil
    }
}
