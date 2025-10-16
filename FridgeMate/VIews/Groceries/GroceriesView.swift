//
//  GroceriesView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 16/10/2025.
// ❗️目前没有删除功能

import SwiftUI

struct GroceriesView: View {
    // 添加要买的食物
    @State private var showAddItemSheet = false
    @State private var newItemName = ""
    
    // 模拟数据
    @State private var groceries = [
        ("Tomatoes", "2", "2025/10/10", "Out of date", Color.red),
        ("Apples", "5", "2025/10/18", "Soon to Expire", Color.orange),
        ("Eggs", "10", "2025/11/01", "Fresh", Color.green)
    ]
    @State private var shoppingList = ["Tomatoes", "Eggs", "Apples"]
    
    @State private var checkedItems: Set<String> = []
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                //背景颜色
                Color("BackgroundGrey")
                    .ignoresSafeArea()
                
                VStack {
                    
                    // —— 冰箱中的食材部分 ——
                    // 标题
                    HStack {
                        Text("My Groceries")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // 食材卡片
                    ScrollView {
                        ForEach(groceries, id: \.0) { item in
                            GroceriesCardView(
                                name: item.0,
                                amount: item.1,
                                expiration: item.2,
                                status: item.3,
                                color: item.4
                            )
                            .padding(.horizontal)
                            
                        }
                    }
                    
                    // —— 待购清单部分 ——
                    HStack {
                        Text("Shopping List")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // 待购食材卡片
                    ScrollView {
                        ForEach(shoppingList, id: \.self) { item in
                            ShoppingListCardView(
                                itemName: item,
                                isChecked: checkedItems.contains(item),
                                onToggle: {
                                    if checkedItems.contains(item) {
                                        checkedItems.remove(item)
                                    } else {
                                        checkedItems.insert(item)
                                    }
                                }
                                
                            )
                            .padding(.horizontal)

                        }
                    }
                    
                    
                    // 添加待买食物按钮
                    Button(action: {
                        // TODO: 实现添加待买食物弹窗功能
                        showAddItemSheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                            Text("Add Item")
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(width: 220, height: 50)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                        .padding(.bottom, 80)
                    }
                    
                    
                }
            }
        }
    }
}

#Preview {
    GroceriesView()
}
