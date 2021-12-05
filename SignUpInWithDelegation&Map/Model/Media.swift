//
//  Media.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 30/11/2021.
//

import Foundation


struct Media: Codable {
    var artistName: String?
    var trailer: String?
    var PosterUrl: String
    var longDescription: String?
    var country: String?
    var trackName: String?
    var typeOfMedia: String?
    var releaseDate: String?
    
    enum CodingKeys: String , CodingKey {
        case artistName, country, longDescription, trackName ,releaseDate
        case trailer = "previewUrl"
        case PosterUrl = "artworkUrl100"
        case typeOfMedia = "primaryGenreName"
    }
}
