//
//  InventoryCheckPopupView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 17/10/2025.
//
// 功能基本接入
// 可以根据groceries页面的库存来提供已有食材和缺少食材
// 勾选缺少食材可以加入shoppinglist

import SwiftUI

struct InventoryCheckPopupView: View {
    var recipe: Recipe
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var pantry = PantryStore.shared

    // 交互状态
    @State private var selectedItems: Set<String> = []
    @State private var itemsInStock: [String] = []
    @State private var missingItems: [String] = []
    
   
    @inline(__always)
    private func norm(_ s: String) -> String {
        GroceryItem.norm(s)
    }
    
    // 重新计算库存对比
    private func recompute() {
        // 从 PantryStore 获取“可用名称集合”
        let inStockSet = pantry.availableNameSet(ignoreExpired: true)
        let ingrs = recipe.ingredients
        
        let inStock = ingrs.filter { inStockSet.contains(norm($0)) }
        let missing = ingrs.filter { !inStockSet.contains(norm($0)) }
        
        self.itemsInStock = inStock
        self.missingItems = missing
        
        // 如果缺货列表变化，把已选中但不在缺货里的项清掉
        selectedItems = selectedItems.intersection(Set(missing))
    }

    private func toggleSelection(_ item: String) {
        if selectedItems.contains(item) { selectedItems.remove(item) }
        else { selectedItems.insert(item) }
    }

    var body: some View {
        VStack(spacing: 16) {
            // 顶部标题 & 关闭
            ZStack {
                Text("Inventory Comparison")
                    .font(.headline)
                    .padding(.top)
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding()
                    }
                }
            }
            
            Divider()
            
            // Description
            VStack(alignment: .leading, spacing: 10) {
                Text("Description")
                    .font(.subheadline).bold()
                Text(recipe.intro ?? "No description yet.")
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 1)
            
            Divider()
            
            // In Stock
            VStack(alignment: .leading, spacing: 10) {
                Text("Items in Stock")
                    .font(.subheadline).bold()
                if itemsInStock.isEmpty {
                    Text("None").foregroundColor(.secondary)
                } else {
                    Text(itemsInStock.joined(separator: ", "))
                        .foregroundColor(.green)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 1)
            
            Divider()
            
            // Missing
            VStack(alignment: .leading, spacing: 10) {
                Text("Missing Ingredients")
                    .font(.subheadline).bold()
                
                if missingItems.isEmpty {
                    Text("All ingredients are available ")
                        .foregroundColor(.secondary)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(missingItems, id: \.self) { item in
                            HStack(spacing: 8) {
                                Image(systemName: selectedItems.contains(item) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedItems.contains(item) ? .green : .black)
                                    .font(.system(size: 20))
                                    .onTapGesture { toggleSelection(item) }
                                Text(item)
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 1)
            
            // 加入购物清单
            Button {
                let toAdd = Array(selectedItems)
                if !toAdd.isEmpty {
                    ShoppingListStore.shared.add(items: toAdd)
                }
                dismiss()
            } label: {
                Text(missingItems.isEmpty ? "Close" : "Add to the Shopping List")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 1)
            }
            .disabled(missingItems.isEmpty) // 没有缺货就禁用添加
            .padding(.top, 6)
            
            Spacer(minLength: 0)
        }
        .padding()
        .background(Color(.systemGray6))
        .onAppear { recompute() }
        // 库存变化时自动刷新
        .onChange(of: pantry.items) { _ in
            recompute()
        }
        .presentationDetents([.medium, .large])
    }
}
