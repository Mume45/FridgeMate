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
    // 库存（My Groceries）
    @ObservedObject private var pantry = PantryStore.shared

    // 添加 Shopping List 项
    @State private var showAddItemSheet = false
    @State private var newItemName = ""
    @State private var addSheetDetent: PresentationDetent = .fraction(0.35)

    // Add to Widget
    @State private var showHowToAddWidgetAlert = false

    // Shopping List
    @State private var shoppingList: [String] = []
    @State private var checkedItems: Set<String> = []

    // 编辑弹窗状态（不用引用 GroceryItem 类型，避免冲突）
    @State private var editingItemName: String? = nil
    @State private var editingItemAmount: Int = 1
    @State private var editingItemExpiration: Date? = nil

    // 日期格式
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd"
        return f
    }()

    // 映射 My Groceries 行数据（仅用字段，避免类型名）
    private var groceriesRows: [(name: String, amountText: String, expirationText: String, status: String, color: Color, amount: Int, expiration: Date?)] {
        pantry.all().map { item in
            let name = item.name
            let amount = item.amount
            let amountText = String(amount)
            let expiration = item.expiration
            let expirationText = (expiration != nil) ? dateFormatter.string(from: expiration!) : "—"
            let (status, color) = statusAndColor(amount: amount, expiration: expiration)
            return (name, amountText, expirationText, status, color, amount, expiration)
        }
    }

    // 不引用 GroceryItem 类型，改为用字段判断
    private func statusAndColor(amount: Int, expiration: Date?) -> (String, Color) {
        if amount <= 0 { return ("Out of stock", .gray) }
        if let exp = expiration {
            let cal = Calendar.current
            let today = cal.startOfDay(for: Date())
            let expDay = cal.startOfDay(for: exp)
            if expDay < today { return ("Out of date", .red) }
            if let days = cal.dateComponents([.day], from: today, to: expDay).day, days <= 7 {
                return ("Soon to Expire", .orange)
            }
            return ("Fresh", .green)
        } else {
            return ("Fresh", .green)
        }
    }

    // 勾选 Shopping List → 入库；取消 → 从库存移除
    private func syncPantry(for item: String, checked: Bool) {
        if checked {
            pantry.upsert(name: item, amount: 1, expiration: nil)
        } else {
            pantry.remove(name: item)
        }
    }

    private func refreshWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }

    // 打开编辑页（用字段存状态）
    private func openEditor(name: String, amount: Int, expiration: Date?) {
        editingItemName = name
        editingItemAmount = max(1, amount)
        editingItemExpiration = expiration
    }

    // 保存编辑
    private func saveEditor(name: String, amount: Int, expiration: Date?) {
        pantry.upsert(name: name, amount: max(1, amount), expiration: expiration)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundGrey").ignoresSafeArea()

                VStack {
                    // —— My Groceries —— //
                    HStack {
                        Text("My Groceries").font(.title2).bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    List {
                        ForEach(groceriesRows.indices, id: \.self) { i in
                            let row = groceriesRows[i]
                            GroceriesCardView(
                                name: row.name,
                                amount: row.amountText,
                                expiration: row.expirationText,
                                status: row.status,
                                color: row.color
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                openEditor(name: row.name, amount: row.amount, expiration: row.expiration)
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete { indexSet in
                            let names = indexSet.compactMap { idx in
                                groceriesRows.indices.contains(idx) ? groceriesRows[idx].name : nil
                            }
                            names.forEach { pantry.remove(name: $0) }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)

                    // —— Shopping List —— //
                    HStack {
                        Text("Shopping List").font(.title2).bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)

                    List {
                        ForEach(shoppingList, id: \.self) { item in
                            ShoppingListCardView(
                                itemName: item,
                                isChecked: checkedItems.contains(item),
                                onToggle: {
                                    if checkedItems.contains(item) {
                                        // 取消购入：从库存移除（可按需决定是否加回清单）
                                        checkedItems.remove(item)
                                        syncPantry(for: item, checked: false)
                                    } else {
                                        // 勾选购入：加入库存，并从清单移除
                                        checkedItems.insert(item)
                                        syncPantry(for: item, checked: true)
                                        ShoppingListStore.shared.remove(item)
                                        shoppingList = ShoppingListStore.shared.all()
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

                    // —— Add Item —— //
                    Button(action: {
                        addSheetDetent = .fraction(0.35)
                        showAddItemSheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill").foregroundColor(.green)
                            Text("Add Item").foregroundColor(.black).fontWeight(.medium)
                        }
                        .padding()
                        .frame(width: 220, height: 50)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                    .padding(.top, 4)

                    // —— Add to Widget 提示 —— //
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
            shoppingList = ShoppingListStore.shared.all()
            refreshWidgets()
        }
        // —— 编辑库存弹窗（不用引用 GroceryItem 类型） —— //
        .sheet(isPresented: Binding(
            get: { editingItemName != nil },
            set: { if !$0 { editingItemName = nil } }
        )) {
            if let name = editingItemName {
                EditGroceryView(
                    name: name,
                    amount: editingItemAmount,
                    expiration: editingItemExpiration
                ) { newName, newAmount, newExp in
                    saveEditor(name: newName, amount: newAmount, expiration: newExp)
                }
            }
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
