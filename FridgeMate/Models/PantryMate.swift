//
//  PantryMate.swift
//  FridgeMate
//
//  Created by 袁钟盈 on 2025/10/18.
//

import Foundation

final class PantryStore {
    static let shared = PantryStore()
    private init() { load() }
    
    private let key = "pantry_items_v1"
    
    private(set) var items: Set<String> = []
    
    
    func seedIfEmpty(_ samples: [String] = ["Eggs", "Milk", "Butter"]) {
        if items.isEmpty {
            items = Set(samples.map { $0.lowercased().trimmingCharacters(in: .whitespaces) })
            save()
        }
    }
    
    func add(_ name: String) {
            let key = name.lowercased().trimmingCharacters(in: .whitespaces)
            guard !key.isEmpty else { return }
            items.insert(key)
            save()
        }
    
    func remove(_ name: String) {
            let key = name.lowercased().trimmingCharacters(in: .whitespaces)
            items.remove(key)
            save()
        }
    
    private func save() {
            let array = Array(items)
            UserDefaults.standard.set(array, forKey: key)
        }
        private func load() {
            if let arr = UserDefaults.standard.stringArray(forKey: key) {
                items = Set(arr)
            }
        }
}
