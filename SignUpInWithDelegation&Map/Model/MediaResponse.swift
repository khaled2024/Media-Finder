//
//  MediaResponse.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 30/11/2021.
//

import Foundation

struct MediaResponse: Decodable{
    var resultCount: Int
    var results : [Media]
}
