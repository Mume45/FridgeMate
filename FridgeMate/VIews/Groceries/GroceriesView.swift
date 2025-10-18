//
//  GroceriesView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 16/10/2025.


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
                    
                    // 食材卡片 加入左滑删除功能
                    List{
                        ForEach(groceries.indices, id: \.self) { idx in
                            let item = groceries[idx]
                            GroceriesCardView(
                                name: item.0,
                                amount: item.1,
                                expiration: item.2,
                                status: item.3,
                                color: item.4
                            )
                            .padding(.horizontal)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive){
                                    groceries.remove(at: idx)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .frame(maxHeight: 300)
                    
                    // —— 待购清单部分 ——
                    HStack {
                        Text("Shopping List")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // 待购食材卡片 加入左滑删除
                    List {
                        ForEach(Array(shoppingList.enumerated()), id: \.offset) { index, item in
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
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    checkedItems.remove(item)
                                    shoppingList.remove(at: index)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .frame(maxHeight: 360)
                    
                    
                    // 添加待买食物按钮
                    Button(action: {
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
                    .sheet(isPresented: $showAddItemSheet) {
                        AddToShoppingListSheet(
                            name: $newItemName,
                            onAdd: { name in
                                addToShoppingList(name)
                                newItemName = ""
                                showAddItemSheet = false
                            },
                            onCancel: {
                                newItemName = ""
                                showAddItemSheet = false
                            }
                        )
                        .presentationDetents([.fraction(0.35), .medium])
                    }
                }
            }
        }
    }
    
    private func addToShoppingList(_ raw: String) {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let name = trimmed.prefix(1).uppercased() + trimmed.dropFirst()
        if !shoppingList.contains(where: { $0.caseInsensitiveCompare(name) == .orderedSame }) {
            shoppingList.insert(name, at: 0)
        }
    }
}

private struct AddToShoppingListSheet: View {
    @Binding var name: String
        var onAdd: (String) -> Void
        var onCancel: () -> Void
    
    var body: some View {
            VStack(spacing: 16) {
                Capsule().fill(Color.secondary.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)

                Text("Add to Shopping List")
                    .font(.headline)

                TextField("Item name (e.g., Milk)", text: $name)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .submitLabel(.done)
                    .onSubmit {
                        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        onAdd(trimmed)
                    }

                HStack {
                    Button("Cancel", action: onCancel)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(10)

                    Button("Add") {
                        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        onAdd(trimmed)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.4) : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                Spacer(minLength: 8)
            }
            .padding(.horizontal, 20)
        }
    }
    
    
    
    








#Preview {
    GroceriesView()
}
