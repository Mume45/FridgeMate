//
//  GroceriesView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 16/10/2025.

// 已添加删除功能

import SwiftUI
import WidgetKit

struct GroceriesView: View {
    // 添加要买的食物
    @State private var showAddItemSheet = false
    @State private var newItemName = ""
    @State private var addSheetDetent: PresentationDetent = .fraction(0.35)

    // Add to Widget 提示
    @State private var showHowToAddWidgetAlert = false
    
    //模拟数据
    @State private var groceries = [
        ("Tomatoes", "2", "2025/10/10", "Out of date", Color.red),
        ("Apples", "5", "2025/10/18", "Soon to Expire", Color.orange),
        ("Eggs", "10", "2025/11/01", "Fresh", Color.green)
    ]
    
    // —— Shopping List（从持久化读取） ——
    @State private var shoppingList: [String] = []
    /// 表示已买到 / 入库
    @State private var checkedItems: Set<String> = []
    
    private func syncPantry(for item: String, checked: Bool) {
        if checked { PantryStore.shared.add(item) }
        else { PantryStore.shared.remove(item) }
    }
    
    private func refreshWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundGrey").ignoresSafeArea()
                
                VStack {
                    // —— 冰箱中的食材部分 ——
                    HStack {
                        Text("My Groceries")
                            .font(.title2).bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // 用 List 承载，才能稳定支持左滑删除；外观保持卡片风格
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
                            groceries.remove(atOffsets: indexSet)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    
                    // —— 待购清单部分 ——
                    HStack {
                        Text("Shopping List")
                            .font(.title2).bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    // Shopping List：保持卡片外观 + 左滑删除
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
                                    // 勾选仅切换 UI；如需也写入持久化，可在此处保存状态
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
                    
                    // Add to Widget 按钮（刷新小组件并提示如何添加）
                    Button {
                        refreshWidgets()
                        showHowToAddWidgetAlert = true
                    } label: {
                        Text("Add to Widget")
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                            .padding()
                            .frame(width: 220, height: 50)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                    }
                    .padding(.bottom, 80)
                    .alert("Add the Widget", isPresented: $showHowToAddWidgetAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Long-press the Home Screen → tap “+” → search “FridgeMate” → add the “Shopping List” widget.")
                    }
                }
            }
        }
        .onAppear {
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
            VStack(spacing: 16) {
                ZStack {
                    Text("Add Shopping Item")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    HStack {
                        Spacer()
                        Button("Cancel") {
                            newItemName = ""
                            showAddItemSheet = false
                        }
                        .foregroundColor(.black)
                        .padding(.trailing, 12)
                        .padding(.top, 6)
                    }
                }
                
                TextField("e.g., Tomatoes", text: $newItemName)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                    .padding(14)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    .padding(.horizontal, 20)
                
                Button {
                    let name = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !name.isEmpty else { return }
                    ShoppingListStore.shared.add(name)
                    shoppingList = ShoppingListStore.shared.all()
                    newItemName = ""
                    showAddItemSheet = false
                    refreshWidgets()
                } label: {
                    Text("Add")
                        .foregroundColor(.black)
                        .bold()
                        .frame(width: 200, height: 30)
                        .padding()
                        .background(Color.white.opacity(newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1))
                        .cornerRadius(12)
                        .shadow(radius: 1)
                }
                .disabled(newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
                Spacer(minLength: 8)
            }
            .padding(.bottom, 16)
            .background(Color(.systemGray6))
            .presentationDetents([.fraction(0.35)])
            .onAppear { addSheetDetent = .fraction(0.35) }
        }
    }
}

#Preview {
    GroceriesView()
}
