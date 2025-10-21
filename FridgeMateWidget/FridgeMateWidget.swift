//
//  FridgeMateWidget.swift
//  FridgeMateWidget
//
//  Created by ZhongyingYuan, 24699175 on 2025/10/18.
//

import WidgetKit
import SwiftUI


struct ShoppingListEntry: TimelineEntry {
    let date: Date
    let items: [String]
}


struct ShoppingListProvider: TimelineProvider {
    func placeholder(in context: Context) -> ShoppingListEntry {
        ShoppingListEntry(date: Date(), items: ["Milk", "Eggs", "Bread"])
    }

    func getSnapshot(in context: Context, completion: @escaping (ShoppingListEntry) -> Void) {
        completion(ShoppingListEntry(date: Date(), items: loadItems()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ShoppingListEntry>) -> Void) {
        let entry = ShoppingListEntry(date: Date(), items: loadItems())
        completion(Timeline(entries: [entry],
                            policy: .after(Date().addingTimeInterval(60 * 30))))
    }

    private func loadItems() -> [String] {
        guard let defaults = UserDefaults(suiteName: APP_GROUP_ID) else { return [] }
        return defaults.stringArray(forKey: SHOPPING_LIST_KEY) ?? []
    }
}


struct ShoppingListWidgetView: View {
    @Environment(\.widgetFamily) private var family
    var entry: ShoppingListProvider.Entry


    private let rowHeight: CGFloat = 18
    private let rowSpacing: CGFloat = 6
    private let headerHeight: CGFloat = 24
    private let sideInset: CGFloat = 12
    private let stripeWidth: CGFloat = 6
    private let stripeCorner: CGFloat = 3
    private var maxRows: Int {
        switch family {
        case .systemSmall: return 4
        case .systemMedium: return 7
        default: return 4
        }
    }

    var body: some View {
        let shown = Array(entry.items.prefix(maxRows))
        let more = max(entry.items.count - shown.count, 0)
        let listFixedHeight = CGFloat(maxRows) * rowHeight + CGFloat(maxRows - 1) * rowSpacing
        let moreLineHeight: CGFloat = 14

        ZStack {
       
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))

            VStack(alignment: .leading, spacing: 10) {

     
                HStack(spacing: 8) {
                    ZStack {
                        Circle().fill(Color.green.opacity(0.14))
                        Image(systemName: "cart.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(width: 26, height: 26)

                    Text("Shopping List")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    Spacer(minLength: 0)

 
                    Text("\(entry.items.count)")
                        .font(.caption).bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.green.opacity(0.14)))
                        .foregroundColor(.green)
                }
                .frame(height: headerHeight)

               
                if shown.isEmpty {
               
                    VStack(alignment: .leading, spacing: rowSpacing) {
                        Text("No items yet")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(height: rowHeight, alignment: .center)
                        Spacer(minLength: 0)
                    }
                    .frame(height: listFixedHeight + moreLineHeight)
                } else {
                    VStack(alignment: .leading, spacing: rowSpacing) {
                        ForEach(shown, id: \.self) { item in
                            HStack(spacing: 8) {
                                Image(systemName: "circle") // 未勾选样式
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                Text(item)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                Spacer(minLength: 0)
                            }
                            .frame(height: rowHeight)
                        }

                        
                        Text(more > 0 ? "+\(more) more" : " ")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(height: moreLineHeight, alignment: .topLeading)
                            .opacity(more > 0 ? 1 : 0)
                    }
                    .frame(height: listFixedHeight + moreLineHeight)
                    .clipped()
                }

                Spacer(minLength: 0)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, sideInset)
        }
       
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: stripeCorner, style: .continuous)
                .fill(Color.green)
                .frame(width: stripeWidth)
                .padding(.vertical, 10)
        }
        .applyWidgetBackground(Color.clear) // iOS17 containerBackground，旧系统 fallback
        .padding(6)
    }
}


@main
struct FridgeMateWidget: Widget {
    static let kind = WIDGET_KIND

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: Self.kind, provider: ShoppingListProvider()) { entry in
            ShoppingListWidgetView(entry: entry)
        }
        .configurationDisplayName("Shopping List")
        .description("Quickly glance at your shopping items.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


#Preview(as: .systemSmall) {
    FridgeMateWidget()
} timeline: {
    ShoppingListEntry(date: .now, items: ["Cheese", "Tomatoes", "Bread", "Beef", "Milk", "Apples"])
}


private extension View {
   
    @ViewBuilder
    func applyWidgetBackground(_ style: some ShapeStyle) -> some View {
        if #available(iOS 17.0, *) {
            self.containerBackground(style, for: .widget)
        } else {
            self.background(style)
        }
    }
}
