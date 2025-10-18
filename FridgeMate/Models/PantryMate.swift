//
//  PantryMate.swift
//  FridgeMate
//
//  Created by ZhongyingYuan, 24699175 on 2025/10/18.
//

import Foundation

final class PantryStore: ObservableObject {
    static let shared = PantryStore()
    private init() { load() }


    private let suite = "group.com.fridgemate.shared"
    private lazy var defaults: UserDefaults = {
        UserDefaults(suiteName: suite) ?? .standard
    }()

    private let key = "pantry_items_v2"

    // 发布库存变化，界面会自动刷新
    @Published private(set) var items: Set<String> = []

    @inline(__always)
    private func norm(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    func seedIfEmpty(_ samples: [String] = ["Eggs", "Milk", "Butter"]) {
        if items.isEmpty {
            items = Set(samples.map(norm))
            save()
        }
    }

    func all() -> [String] { Array(items) }

    func add(_ name: String) {
        let k = norm(name)
        guard !k.isEmpty else { return }
        if items.insert(k).inserted { save() }
    }

    func addMany(_ names: [String]) {
        var changed = false
        for n in names.map(norm) where !n.isEmpty {
            if items.insert(n).inserted { changed = true }
        }
        if changed { save() }
    }

    func remove(_ name: String) {
        if items.remove(norm(name)) != nil { save() }
    }

    func contains(_ name: String) -> Bool {
        items.contains(norm(name))
    }

    func clear() {
        items.removeAll()
        save()
    }

    func debugPrintAll() {
        print(" Pantry Items =", Array(items))
    }


    private func save() {
        defaults.set(Array(items), forKey: key)
    }

    private func load() {
        if let arr = defaults.stringArray(forKey: key) {
            items = Set(arr.map(norm))
        } else {
            items = []
        }
    }
}
