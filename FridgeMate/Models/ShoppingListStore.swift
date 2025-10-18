//
//  ShoppingListStore.swift
//  FridgeMate
//
//  Created by 袁钟盈 on 2025/10/18.
// 购物清单数据源

import Foundation

final class ShoppingListStore {
    static let shared = ShoppingListStore()
    private init() { load() }
    
    private let key = "shopping_List_v1"
    private var items: [String] = []
    
    func all() -> [String] {items}
    
    func add(_ name: String) {
        let cleaned = normalize(name)
        guard !cleaned.isEmpty else { return }
        if !containsCaseInsensitive(cleaned) {
            items.append(cleaned)
            save()
        }
    }
    
    func add(items names: Set<String>) {
           var changed = false
           for n in names {
               let cleaned = normalize(n)
               guard !cleaned.isEmpty else { continue }
               if !containsCaseInsensitive(cleaned) {
                   items.append(cleaned)
                   changed = true
               }
           }
           if changed { save() }
       }
       
       func remove(_ name: String) {
           if let idx = indexCaseInsensitive(of: name) {
               items.remove(at: idx)
               save()
           }
       }
    
    func clear() {
           items.removeAll()
           save()
       }
    
    private func normalize(_ s: String) -> String {
            s.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        private func containsCaseInsensitive(_ s: String) -> Bool {
            indexCaseInsensitive(of: s) != nil
        }
        private func indexCaseInsensitive(of s: String) -> Int? {
            let lower = s.lowercased()
            return items.firstIndex { $0.lowercased() == lower }
        }
        
        private func save() {
            UserDefaults.standard.set(items, forKey: key)
        }
        private func load() {
            items = UserDefaults.standard.stringArray(forKey: key) ?? []
        }
}
