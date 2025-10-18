//
//  InventoryCheckPopupView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 17/10/2025.
// TODO: 功能未接入

import SwiftUI

struct InventoryCheckPopupView: View {
    var recipe: Recipe
    
    // 选中的缺失食材
    @State private var selectedItems: Set<String> = []
    private func toggleSelection(_ item: String) {
        if selectedItems.contains(item) { selectedItems.remove(item) }
        else { selectedItems.insert(item) }
    }
    
    @Environment(\.dismiss) var dismiss
    
    //  由菜谱食材与库存对比得出
    @State private var itemsInStock: [String] = []
    @State private var missingItems: [String] = []
    
    private func norm(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    // 处理常见复数 -> 单数
    private func singularize(_ word: String) -> String {
        let w = norm(word)
        if w.isEmpty { return w }
        
        // 常见不规则或易错映射（
        let irregular: [String: String] = [
            "tomatoes": "tomato",
            "potatoes": "potato",
            "loaves": "loaf",
            "leaves": "leaf",
            "knives": "knife",
            "mice": "mouse",
            "geese": "goose",
            "children": "child",
            "men": "man",
            "women": "woman",
            "teeth": "tooth",
            "feet": "foot",
            "eggs": "egg"
        ]
        
        if let m = irregular[w] { return m }
        
        // 规则复数
        if w.hasSuffix("ies"), w.count > 3 {
            let base = w.dropLast(3)
            return base + "y"
        }
        if w.hasSuffix("oes") || w.hasSuffix("xes") || w.hasSuffix("ses") || w.hasSuffix("zes") {
            return String(w.dropLast(2))
        }
        if w.hasSuffix("s") && !w.hasSuffix("ss") {
            return String(w.dropLast())
        }
        return w
    }
    
    private func computeComparison() {
        PantryStore.shared.seedIfEmpty()
        

        let pantryRaw = PantryStore.shared.items
        let pantrySingular = Set(pantryRaw.map { singularize($0) })
        
        var have: [String] = []
        var miss: [String] = []
        
        for raw in recipe.ingredients {
            let key = singularize(raw)
            if pantrySingular.contains(key) {
                have.append(raw)
            } else {
                miss.append(raw)
            }
        }
        itemsInStock = have
        missingItems = miss
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // 顶部标题和关闭按钮
                ZStack {
                    Text("Inventory Comparison")
                        .font(.headline)
                        .padding(.top, 6)
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                }
                
                // 描述卡片
                if let intro = recipe.intro,
                   !intro.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.subheadline)
                            .bold()
                        Text(intro)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 1)
                }

                Divider()

                // 已有库存
                VStack(alignment: .leading, spacing: 10) {
                    Text("Items in Stock")
                        .font(.subheadline)
                        .bold()
                    Text(itemsInStock.isEmpty ? "—" : itemsInStock.joined(separator: ", "))
                        .font(.body)
                        .foregroundColor(.green)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 1)
                
                Divider()
                
                // 缺失食材
                VStack(alignment: .leading, spacing: 10) {
                    Text("Missing Ingredients")
                        .font(.subheadline)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(missingItems, id: \.self) { item in
                            HStack(spacing: 8) {
                                Image(systemName: selectedItems.contains(item) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedItems.contains(item) ? .green : .black)
                                    .font(.system(size: 20))
                                    .onTapGesture { toggleSelection(item) }
                                Text(item).font(.body)
                            }
                        }
                        if missingItems.isEmpty {
                            Text("All ingredients are available.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 1)
                
                // 添加购物清单按钮
                Button(action: {
                    let toAdd = selectedItems.isEmpty ? Set(missingItems) :selectedItems
                    ShoppingListStore.shared.add(items: toAdd)
                    print("Add to shopping list:", selectedItems)
                }) {
                    Text("Add to the Shopping List")
                        .foregroundColor(.black)
                        .frame(width: 200, height: 30)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 1)
                }
                .padding(.top, 10)
                
                Spacer(minLength: 8)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .presentationDetents([.medium, .large])
        .onAppear { computeComparison() }
    }
}

#Preview {
    InventoryCheckPopupView(
        recipe: Recipe(
            name: "Tomato Pasta",
            ingredients: ["Tomato", "Pasta", "Garlic"],
            kind: .beginner,
            intro: "A simple and tasty dish for beginners.",
            imageName: "Pizza"
        )
    )
}
