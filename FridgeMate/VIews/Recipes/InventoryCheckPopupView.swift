//
//  InventoryCheckPopupView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 17/10/2025.
// TODO: 功能未接入

import SwiftUI

struct InventoryCheckPopupView: View {
    var recipe: Recipe
    
    // 当前仅为 UI 状态，不接逻辑
    @State private var selectedItems: Set<String> = []
    // 点击切换选中状态
    private func toggleSelection(_ item: String) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - 模拟数据
    // TODO: 之后应传入该菜谱真实数据，并按照库存状态进行分类
    @State private var itemsInStock = ["Eggs", "Milk", "Butter"]
    @State private var missingItems = ["Tomatoes", "Cheese"]

    var body: some View {
        
        VStack(spacing: 16) {
            
            // 顶部标题和关闭按钮
            ZStack {
                Text("Inventory Comparison")
                    .font(.headline)
                    .padding(.top)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding()
                    }
                }
            }
            
            Divider()
            
            // MARK: - 已有库存
            VStack(alignment: .leading, spacing: 10) {
                Text("Items in Stock")
                    .font(.subheadline)
                    .bold()
                
                // 模拟库存食材，逗号分隔
                Text(itemsInStock.joined(separator: ", "))
                    .font(.body)
                    .foregroundColor(.green)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 1)
            
            Divider()
            
            // MARK: - 缺失食材
            VStack(alignment: .leading, spacing: 10) {
                Text("Missing Ingredients")
                    .font(.subheadline)
                    .bold()
                
                VStack(alignment: .leading, spacing: 6) {
                    // TODO: 当前仅用于 UI 展示（非功能逻辑）
                    // 实际开发中，这里应根据库存数据对比生成缺失食材列表
                    // 并支持用户勾选后加入购物清单
                    ForEach(missingItems, id: \.self) { item in
                        HStack(spacing: 8) {
                            
                            Image(systemName: selectedItems.contains(item) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedItems.contains(item) ? .green : .black)
                                .font(.system(size: 20))
                                .onTapGesture {
                                    toggleSelection(item)
                                }
                            
                            Text(item)
                                .font(.body)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 1)
            
            // MARK: - 添加购物清单按钮
            Button(action: {
                // TODO: 后续功能开发时，将选中食材添加至购物清单
                print("Added to shopping list")
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
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .presentationDetents([.medium]) // 控制底部弹窗高度
    }
}

#Preview {
    InventoryCheckPopupView(
        recipe: Recipe(
            name: "Test Dish",
            ingredients: ["Egg", "Tomato", "Cheese"],
            kind: .beginner,
            intro: "Preview test",
            imageName: "Pizza"
        )
    )
}

