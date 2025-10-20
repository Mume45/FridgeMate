//
//  GroceriesView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 16/10/2025.

// 已添加删除功能
// 添加了把shopping list小组件放在主页上，会实时更新

import SwiftUI
import WidgetKit

struct GroceriesView: View {
    // pantryMate读取
    @ObservedObject private var pantry = PantryStore.shared

    // 添加要买的食物（Shopping List）
    @State private var showAddItemSheet = false
    @State private var newItemName = ""
    @State private var addSheetDetent: PresentationDetent = .fraction(0.35)

    // Add to Widget
    @State private var showHowToAddWidgetAlert = false
    
    //  Shopping List
    @State private var shoppingList: [String] = []
    // 表示已买到 / 入库
    @State private var checkedItems: Set<String> = []
    
    
    private var groceries: [(String, String, String, String, Color)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        return pantry.all().map { item in
            // 名称
            let name = item.name
            // 数量（转成字符串以吻合你原 UI）
            let amountText = String(item.amount)
            // 到期日
            let expirationText: String = {
                if let exp = item.expiration {
                    return formatter.string(from: exp)
                } else {
                    return "—"
                }
            }()
            let (status, color): (String, Color) = statusAndColor(for: item)
            return (name, amountText, expirationText, status, color)
        }
    }
    
    // 生成状态与颜色
    private func statusAndColor(for item: GroceryItem) -> (String, Color) {
        if item.amount <= 0 {
            // 数量为 0 视为“缺货”，
            return ("Out of stock", Color.gray)
        }
        if let exp = item.expiration {
            // 只比较到“日”
            let cal = Calendar.current
            let today = cal.startOfDay(for: Date())
            let expDay = cal.startOfDay(for: exp)
            if expDay < today {
                return ("Out of date", Color.red)
            } else {
                // 距离到期天数
                if let days = cal.dateComponents([.day], from: today, to: expDay).day, days <= 7 {
                    return ("Soon to Expire", Color.orange)
                } else {
                    return ("Fresh", Color.green)
                }
            }
        } else {
            // 没有到期日则视为“新鲜”
            return ("Fresh", Color.green)
        }
    }
    
   
    private func syncPantry(for item: String, checked: Bool) {
        if checked {
            // 购入 → 入库（
            pantry.upsert(name: item, amount: 1, expiration: nil)
        } else {
            // 取消购入 → 从库存移除该名称
            pantry.remove(name: item)
        }
    }
    
    private func refreshWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundGrey").ignoresSafeArea()
                
                VStack {
                    // 冰箱中的食材部分
                    HStack {
                        Text("My Groceries")
                            .font(.title2).bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                   
                    List {
                        ForEach(groceries.indices, id: \.self) { i in
                            let item = groceries[i]
                            GroceriesCardView(
                                name: item.0,
                                amount: item.1,
                                expiration: item.2,
                                status: item.3,
                                color: item.4
                            )
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete { indexSet in
                            // 删除选中的库存项
                            let names = indexSet.compactMap { idx in
                                groceries.indices.contains(idx) ? groceries[idx].0 : nil
                            }
                            names.forEach { pantry.remove(name: $0) }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    
                    // 待购清单部分
                    HStack {
                        Text("Shopping List")
                            .font(.title2).bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    // Shopping List
                    List {
                        ForEach(shoppingList, id: \.self) { item in
                            ShoppingListCardView(
                                itemName: item,
                                isChecked: checkedItems.contains(item),
                                onToggle: {
                                    if checkedItems.contains(item) {
                                        checkedItems.remove(item)
                                        syncPantry(for: item, checked: false)
                                    } else {
                                        checkedItems.insert(item)
                                        syncPantry(for: item, checked: true)
                                    }
                                    refreshWidgets()
                                }
                            )
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete { indexSet in
                            var toRemove: [String] = []
                            for idx in indexSet where shoppingList.indices.contains(idx) {
                                toRemove.append(shoppingList[idx])
                            }
                           
                            toRemove.forEach { ShoppingListStore.shared.remove($0) }
                            shoppingList = ShoppingListStore.shared.all()
                            refreshWidgets()
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    
                    // 添加待买食物按钮
                    Button(action: {
                        addSheetDetent = .fraction(0.35)
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
                    }
                    .padding(.top, 4)
                    
                    // Add to Widget
                    Button {
                        refreshWidgets()
                        showHowToAddWidgetAlert = true
                    } label: {
                        Text("Add to Widget")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.top, 6)
                            .padding(.bottom, 28)
                    }
                    .buttonStyle(.plain)
                    .alert("Add the Widget", isPresented: $showHowToAddWidgetAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Long-press the Home Screen → tap “+” → search “FridgeMate” → add the “Shopping List” widget.")
                    }
                }
            }
        }
        .onAppear {
            // 初始化购物清单
            var list = ShoppingListStore.shared.all()
            if list.isEmpty {
                ShoppingListStore.shared.add(items: ["Cheese", "Tomatoes"])
                list = ShoppingListStore.shared.all()
            }
            shoppingList = list
            refreshWidgets()
        }
        // Add Item
        .sheet(isPresented: $showAddItemSheet) {
            AddShoppingItemView(isPresented: $showAddItemSheet, shoppingList: $shoppingList)
                .presentationDetents([addSheetDetent])
                .presentationDragIndicator(.visible)
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    GroceriesView()
}
