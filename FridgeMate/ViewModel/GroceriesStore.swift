//
//  GroceriesStore.swift
//  FridgeMate
//
//  Created by 袁钟盈 on 2025/10/21.
//

import Foundation
import WidgetKit

private let GROCERIES_KEY = "groceries_v1"

@MainActor
final class GroceriesStore: ObservableObject {
    static let shared = GroceriesStore()
    private init() { load() }

    @Published private(set) var items: [GroceryItem] = []
    @Published var itemBeingEdited: GroceryItem? = nil

    private let defaults = UserDefaults(suiteName: APP_GROUP_ID)!


    func addFromShoppingList(name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        if let idx = items.firstIndex(where: { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame }) {
     
            items[idx].amount += 1
        } else {
            items.insert(GroceryItem(name: trimmed, amount: 1, expiration: nil), at: 0)
        }
        save()
    }

    func update(_ item: GroceryItem) {
        if let i = items.firstIndex(where: { $0.id == item.id }) {
            items[i] = item
            save()
        }
    }

    func delete(_ item: GroceryItem) {
        items.removeAll { $0.id == item.id }
        save()
    }


    func presentEdit(for item: GroceryItem) { itemBeingEdited = item }
    func dismissEdit() { itemBeingEdited = nil }


    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            defaults.set(data, forKey: GROCERIES_KEY)
        }
        
    }

    private func load() {
        guard let data = defaults.data(forKey: GROCERIES_KEY),
              let arr = try? JSONDecoder().decode([GroceryItem].self, from: data) else {
            items = []
            return
        }
        items = arr
    }
}
