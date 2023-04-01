//
//  ItemModel.swift
//  TradingStore
//
//  Created by ARMBP on 3/24/23.
//

import Foundation


struct ItemModel: Decodable{
    let name: String
    let description: String
    let rating: Double
    let numberOfReviews: Int
    let price: Int
    let colors: [String]
    let imageUrls: [String]
}
 






