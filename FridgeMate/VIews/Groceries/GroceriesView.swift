//
//  GroceriesView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 16/10/2025.

// 已添加删除功能

import SwiftUI

struct GroceriesView: View {
    // 添加要买的食物
    @State private var showAddItemSheet = false
    @State private var newItemName = ""
    @State private var addSheetDetent: PresentationDetent = .fraction(0.35)
    
    //模拟数据
    @State private var groceries = [
        ("Tomatoes", "2", "2025/10/10", "Out of date", Color.red),
        ("Apples", "5", "2025/10/18", "Soon to Expire", Color.orange),
        ("Eggs", "10", "2025/11/01", "Fresh", Color.green)
    ]
    
    // Shopping List
    @State private var shoppingList: [String] = []
    //表示已买到 / 入库
    @State private var checkedItems: Set<String> = []
    
    private func syncPantry(for item: String, checked: Bool) {
        if checked { PantryStore.shared.add(item) }
        else { PantryStore.shared.remove(item) }
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
                        // 左滑删除
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
                    
                    // Shopping List + 左滑删除
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
                        .padding(.bottom, 80)
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
        }
        // Add Item 弹窗
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
