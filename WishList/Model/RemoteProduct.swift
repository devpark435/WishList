//
//  RemoteProduct.swift
//  WishList
//
//  Created by 박현렬 on 4/15/24.
//

import Foundation

struct RemoteProduct: Decodable{
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let category: String
    let thumbnail: URL
    let images: [URL]
}
