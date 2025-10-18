//
//  ShoppingListStore.swift
//  FridgeMate
//
//  Created by ZhongyingYuan, 24699175 2025/10/18.
// 购物清单数据源
// 小组件

import Foundation
import WidgetKit


private let APP_GROUP_ID = "group.com.fridgemate.shared"
private let SHOPPING_LIST_KEY = "shopping_list_v1"
private let WIDGET_KIND = "FridgeMateWidget"

final class ShoppingListStore {
    static let shared = ShoppingListStore()
    private init() { load() }

    private let defaults = UserDefaults(suiteName: APP_GROUP_ID) ?? .standard
    private var items: [String] = []

    func all() -> [String] { items }

    func add(_ name: String) {
        let s = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !s.isEmpty else { return }
        if !items.contains(where: { $0.lowercased() == s.lowercased() }) {
            items.append(s)
            save()
        }
    }

    func add(items newItems: [String]) {
        var changed = false
        for raw in newItems {
            let s = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !s.isEmpty else { continue }
            if !items.contains(where: { $0.lowercased() == s.lowercased() }) {
                items.append(s)
                changed = true
            }
        }
        if changed { save() }
    }

    func add(items set: Set<String>) { add(items: Array(set)) }

    func remove(_ name: String) {
        if let i = items.firstIndex(where: { $0.lowercased() == name.lowercased() }) {
            items.remove(at: i)
            save()
        }
    }


    private func save() {
        defaults.set(items, forKey: SHOPPING_LIST_KEY)
        WidgetCenter.shared.reloadTimelines(ofKind: WIDGET_KIND)
    }

    private func load() {
        items = defaults.stringArray(forKey: SHOPPING_LIST_KEY) ?? []
    }
}
