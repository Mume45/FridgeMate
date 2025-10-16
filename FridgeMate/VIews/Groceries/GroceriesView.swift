//
//  GroceriesView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 16/10/2025.
// ❗️目前没有删除功能

import SwiftUI

struct GroceriesView: View {
    
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
                    
                }
            }
        }
    }
}

#Preview {
    GroceriesView()
}
