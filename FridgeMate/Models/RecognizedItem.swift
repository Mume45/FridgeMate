//
//  RecognizedItem.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 20/10/2025.
//  识别出来的食物的模型

import Foundation

struct RecognizedItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var amount: Int = 1
    var expiration: Date = Date()
    var isSelected: Bool = false
}
