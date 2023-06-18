//
// Created by Armando Shala on 18.06.23.
//

import SwiftUI

struct JsonRepresentation: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var productID: String
    var displayName: String
    var altText: String
    var image1: String
    var image2: String
    var price: Int
    var color: String

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case displayName, altText, image1, image2, price, color
    }

}