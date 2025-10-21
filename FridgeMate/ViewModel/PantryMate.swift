//
//  PantryMate.swift
//  FridgeMate
//
//  Created by ZhongyingYuan, 24699175 on 2025/10/18.
//

import Foundation

//物品数据模型（
struct GroceryItem: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var key: String
    var amount: Int
    var expiration: Date?

    init(id: UUID = UUID(), name: String, amount: Int = 1, expiration: Date? = nil) {
        self.id = id
        self.name = name
        self.key = GroceryItem.norm(name)
        self.amount = max(0, amount)
        self.expiration = expiration
    }

    
    static func norm(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    /// 是否在库
    var isAvailable: Bool { amount > 0 }

    /// 是否已过期
    var isExpired: Bool {
        guard let exp = expiration else { return false }
        let today = Calendar.current.startOfDay(for: Date())
        return exp < today
    }
}

//  库存仓库
@MainActor
final class PantryStore: ObservableObject {
    static let shared = PantryStore()
    private init() { load() }

 
    private let suite = "group.com.fridgemate.shared"
    private lazy var defaults: UserDefaults = {
        UserDefaults(suiteName: suite) ?? .standard
    }()


    private let key = "pantry_items_v3"

    // 发布库存变化，界面会自动刷新
    @Published private(set) var items: [GroceryItem] = []


    /// 按名称（不区分大小写）排序后的全部库存条目
    func all() -> [GroceryItem] {
        items.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }

    /// 供菜谱对比使用的“可用名称集合”
    /// 默认忽略已过期项，且数量必须 > 0 才算在库
    func availableNameSet(ignoreExpired: Bool = true) -> Set<String> {
        let usable = items.filter {
            if ignoreExpired { return $0.isAvailable && !$0.isExpired }
            return $0.isAvailable
        }
        return Set(usable.map { GroceryItem.norm($0.name) })
    }


    /// 按名称插入或合并（同名累计数量；过期日取更早的一个）
    func upsert(name: String, amount: Int = 1, expiration: Date? = nil) {
        let k = GroceryItem.norm(name)
        guard !k.isEmpty else { return }

        if let i = items.firstIndex(where: { $0.key == k }) {
            // 已存在：数量累加；若传入过期日，则保留更早的日期
            items[i].amount = max(0, items[i].amount + amount)
            if let exp = expiration {
                if let old = items[i].expiration {
                    items[i].expiration = min(old, exp)
                } else {
                    items[i].expiration = exp
                }
            }
        } else {
            items.append(GroceryItem(name: name, amount: max(0, amount), expiration: expiration))
        }
        save()
    }

    /// 批量添加
    func addMany(_ names: [String], amount: Int = 1, expiration: Date? = nil) {
        for n in names {
            upsert(name: n, amount: amount, expiration: expiration)
        }
    }

    /// 设定绝对数量
    func setAmount(for id: UUID, to value: Int) {
        guard let i = items.firstIndex(where: { $0.id == id }) else { return }
        items[i].amount = max(0, value)
        save()
    }

    /// 数量 +1 / -1
    func increment(id: UUID) { changeAmount(id: id, delta: +1) }
    func decrement(id: UUID) { changeAmount(id: id, delta: -1) }
    private func changeAmount(id: UUID, delta: Int) {
        guard let i = items.firstIndex(where: { $0.id == id }) else { return }
        items[i].amount = max(0, items[i].amount + delta)
        save()
    }

    /// 设置/清空过期日（通过 id）
    func setExpiration(for id: UUID, to date: Date?) {
        guard let i = items.firstIndex(where: { $0.id == id }) else { return }
        items[i].expiration = date
        save()
    }

    /// 删除（通过 id）
    func remove(id: UUID) {
        items.removeAll { $0.id == id }
        save()
    }

    /// 删除（通过名称）
    func remove(name: String) {
        let k = GroceryItem.norm(name)
        items.removeAll { $0.key == k }
        save()
    }

    /// 清空（测试/重置用）
    func clear() {
        items.removeAll()
        save()
    }

    /// 控制台调试输出
    func debugPrintAll() {
        let lines = items.map { "\($0.name) [qty:\($0.amount)] exp:\($0.expiration?.description ?? "nil")" }
        print("Pantry =", lines)
    }


    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            defaults.set(data, forKey: key)
        }
        // 明确触发以确保视图刷新
        objectWillChange.send()
        
        // 每次保存库存后，自动更新过期提醒
        Task { @MainActor in
            if await NotificationManager.shared.isAuthorized {
                NotificationManager.shared.scheduleExpirationReminders()
            }
        }
    }

    private func load() {
        if let data = defaults.data(forKey: key),
           let decoded = try? JSONDecoder().decode([GroceryItem].self, from: data) {
            items = decoded
        } else {
            items = []
        }
    }
}
