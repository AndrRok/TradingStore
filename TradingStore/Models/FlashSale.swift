//
//  FlashSale.swift
//  TradingStore
//
//  Created by ARMBP on 3/22/23.
//


import Foundation

struct FlashSaleResponse: Codable, Hashable{
    let flashSale: [FlashSales]
}

struct FlashSales: Codable{
    let uuid = UUID()
    private enum CodingKeys : String, CodingKey { case  category, name, price, discount, imageUrl }
    
    let category: String
    let name: String
    let price: Double
    let discount: Int
    let imageUrl: String
}

extension FlashSales: Hashable{
    static func ==(lhs: FlashSales, rhs: FlashSales) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
