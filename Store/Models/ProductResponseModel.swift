//
//  ProductResponseModel.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//  Modified by Eka Kelenjeridze on 26.11.23.
//

import Foundation

//change from Codable to -> Decodable
struct ProductResponseModel: Decodable {
    let products: [ProductModel]
    let total: Int
    let skip: Int
    let limit: Int
}
