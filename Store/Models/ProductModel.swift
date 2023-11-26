//
//  ProductModel.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//  Modified by Eka Kelenjeridze on 26.11.23.
//

import Foundation

//change from Codable to -> Decodable
//correct ProductModel object according to the JSON data and project requirements:
struct ProductModel: Decodable {
    let id: Int
    let title: String
    let description: String
    //price's type is Int in JSON so changed from Double to Int; to change type, codingKeys are needed
    let price: Int
    let discountPercentage: Double
    let rating: Double
    //stock property should be mutable so changed to var
    var stock: Int
    let brand: String
    let category: String
    let thumbnail: String
    let images: [String]
    var selectedAmount: Int?
}
