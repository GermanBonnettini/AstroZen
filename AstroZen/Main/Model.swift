//
//  Model.swift
//  AstroZen
//
//  Created by Cypto Beast on 10/04/2024.
//

import Foundation

struct dataResponse: Decodable {
    let url: String
    
}

struct modelResponse: Decodable {
    let data: [dataResponse]
}
