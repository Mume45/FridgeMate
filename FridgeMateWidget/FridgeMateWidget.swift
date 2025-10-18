//
//  FridgeMateWidget.swift
//  FridgeMateWidget
//
//  Created by ZhongyingYuan, 24699175 on 2025/10/18.
//

import WidgetKit
import SwiftUI

// 与 App 里的常量一致
public let APP_GROUP_ID = "group.com.fridgemate.shared"
public let SHOPPING_LIST_KEY = "shopping_list_v1"
public let WIDGET_KIND = "FridgeMateWidget"


struct ShoppingListProvider: TimelineProvider {
    func placeholder(in context: Context) -> ShoppingListEntry {
        ShoppingListEntry(date: Date(), items: ["Cheese", "Tomatoes", "Garlic"])
    }

    func getSnapshot(in context: Context, completion: @escaping (ShoppingListEntry) -> Void) {
        completion(ShoppingListEntry(date: Date(), items: loadItems()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ShoppingListEntry>) -> Void) {
        let entry = ShoppingListEntry(date: Date(), items: loadItems())
        completion(Timeline(entries: [entry], policy: .never))
    }

    private func loadItems() -> [String] {
        let defaults = UserDefaults(suiteName: APP_GROUP_ID) ?? .standard
        return defaults.stringArray(forKey: SHOPPING_LIST_KEY) ?? []
    }
}


struct ShoppingListEntry: TimelineEntry {
    let date: Date
    let items: [String]
}


struct ShoppingListWidgetView: View {
    var entry: ShoppingListProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Shopping List").font(.headline)
            if entry.items.isEmpty {
                Text("No items yet").foregroundColor(.secondary).font(.subheadline)
            } else {
                ForEach(entry.items.prefix(5), id: \.self) { item in
                    HStack(spacing: 6) {
                        Image(systemName: "circle")
                        Text(item).lineLimit(1)
                    }
                    .font(.subheadline)
                }
                if entry.items.count > 5 {
                    Text("+\(entry.items.count - 5) more")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding()
    }
}

struct FridgeMateWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: WIDGET_KIND, provider: ShoppingListProvider()) { entry in
            ShoppingListWidgetView(entry: entry)
        }
        .configurationDisplayName("Shopping List")
        .description("Quickly glance your shopping items.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    FridgeMateWidget()
} timeline: {
    ShoppingListEntry(date: .now, items: ["Cheese", "Tomatoes", "Garlic"])
}
