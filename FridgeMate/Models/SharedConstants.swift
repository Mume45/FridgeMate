//
//  SharedConstants.swift
//  FridgeMate
//
//  Created by 袁钟盈 on 2025/10/21.
//

import Foundation

// MARK: - App Group / Keys / Widget Kind（两端共享）
public let APP_GROUP_ID = "group.com.fridgemate.shared"
public let SHOPPING_LIST_KEY = "shopping_list_v1"
public let WIDGET_KIND = "FridgeMateWidget"

// MARK: - 共享的 UserDefaults 工具（严禁回退 .standard）
public enum SharedDefaults {
    public static var group: UserDefaults {
        // App Groups 必须在 App 与 Widget 两个 target 的 Signing & Capabilities 里都勾选
        // 这里不用 .standard 回退，便于暴露配置问题
        return UserDefaults(suiteName: APP_GROUP_ID)!
    }

    public static func loadItems() -> [String] {
        group.stringArray(forKey: SHOPPING_LIST_KEY) ?? []
    }

    public static func saveItems(_ items: [String]) {
        group.set(items, forKey: SHOPPING_LIST_KEY)
    }
}
