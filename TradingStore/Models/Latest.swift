//
//  Latest.swift
//  TradingStore
//
//  Created by ARMBP on 3/20/23.
//

import Foundation

struct LatestResponse: Codable, Hashable{
    let latest: [Latests]
}


struct Latests: Codable{
    let uuid = UUID()
    private enum CodingKeys : String, CodingKey { case  category, name, price, imageUrl }
    
    let category: String
    let name: String
    let price: Double
    let imageUrl: String
}


extension Latests: Hashable{
    static func ==(lhs: Latests, rhs: Latests) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
