//
//  ExpirationPolicy.swift
//  FridgeMate
//
//  Created by 顾诗潆
//
import Foundation

enum ExpirationPolicy {
    static func defaultDays(for name: String) -> Int {
        let key = name.lowercased()
        let map: [String:Int] = [
            "apple":14,
            "banana":7,
            "beef":3,
            "chicken":2,
            "pork":3,"fish":2,"shrimp":2,
            "milk":5,"egg":14,"yogurt":10,"bread":4,"tomato":5,"potato":21,"onion":21,
            "lettuce":5,"cabbage":10,"carrot":14,"mushroom":4,"cheese":14,"tofu":5,
            "strawberry":3,"blueberry":5,"broccoli":7,"spinach":4,"cucumber":5,"garlic":30,
            "lemon":14,"lime":14,"orange":14,"grape":7,"avocado":5,"salmon":2,"lamb":3,
            "rice":180,"noodles":180,"dumpling":90,"corn":5,"pepper":7,"chili":10
        ]
        if let v = map[key] { return v }
        return 7
    }
}
