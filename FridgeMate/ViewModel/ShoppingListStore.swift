//
//  ShoppingListStore.swift
//  FridgeMate
//
//  Created by ZhongyingYuan, 24699175 2025/10/18.
// 购物清单数据源
// 小组件

import Foundation
import WidgetKit

final class ShoppingListStore {
    static let shared = ShoppingListStore()
    private init() {
        load()
        sanitizeIfNeeded()
    }

    private let defaults = UserDefaults(suiteName: APP_GROUP_ID)!
    private var items: [String] = []

    func all() -> [String] { items }

    func add(_ name: String) {
        let s = normalized(name)
        guard !s.isEmpty else { return }
        if !items.contains(where: { $0.caseInsensitiveCompare(s) == .orderedSame }) {
            items.append(s)
            save()
        }
    }

    func add(items newItems: [String]) {
        var changed = false
        for raw in newItems {
            let s = normalized(raw)
            guard !s.isEmpty else { continue }
            if !items.contains(where: { $0.caseInsensitiveCompare(s) == .orderedSame }) {
                items.append(s); changed = true
            }
        }
        if changed { save() }
    }

    func remove(_ name: String) {
        let s = normalized(name)
        if let i = items.firstIndex(where: { $0.caseInsensitiveCompare(s) == .orderedSame }) {
            items.remove(at: i)
            save()
        }
    }

    func clearAll() {
        items.removeAll()
        save()
    }

    // MARK: - Private
    private func normalized(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func save() {
        defaults.set(items, forKey: SHOPPING_LIST_KEY)
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func load() {
        items = defaults.stringArray(forKey: SHOPPING_LIST_KEY) ?? []
    }

    /// 第一次启动此版本时做一次清理：去掉 `t:` 示范项、去重 & 去空白
    private func sanitizeIfNeeded() {
        let flagKey = "did_sanitize_v1"
        if defaults.bool(forKey: flagKey) { return }

        var changed = false

        // 1) 去掉以 t: 开头的示例项
        let filtered = items.filter { !$0.lowercased().hasPrefix("t:") }
        if filtered.count != items.count {
            items = filtered
            changed = true
        }

        // 2) 去空白
        let trimmed = items.map { normalized($0) }.filter { !$0.isEmpty }
        if trimmed.count != items.count {
            items = trimmed
            changed = true
        }

        // 3) 忽略大小写去重（保持原顺序）
        var seen = Set<String>()
        var deduped: [String] = []
        for s in items {
            let key = s.lowercased()
            if !seen.contains(key) {
                seen.insert(key)
                deduped.append(s)
            } else {
                changed = true
            }
        }
        items = deduped

        if changed { save() }
        defaults.set(true, forKey: flagKey)
    }
}
