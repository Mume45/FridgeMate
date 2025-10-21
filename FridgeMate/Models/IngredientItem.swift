//
//  IngredientItem.swift
//  FridgeMate
//
//  Created by 顾诗潆
//
import Foundation
import SwiftUI

struct IngredientItem: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var amount: Int
    var expiration: Date
    var imageData: Data
}

extension IngredientItem {
    var image: Image? {
        guard let ui = UIImage(data: imageData) else { return nil }
        return Image(uiImage: ui)
    }
}
