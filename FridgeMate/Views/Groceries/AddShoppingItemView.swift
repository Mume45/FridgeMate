//
//  AddShoppingItemView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 20/10/2025.
//

import SwiftUI
import WidgetKit

struct AddShoppingItemView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var isPresented: Bool
    @Binding var shoppingList: [String]
    
    @State private var newItemName: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            
            // 顶部标题和关闭按钮
            ZStack {
                Text("Add Shopping Item")
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
                isPresented = false
                WidgetCenter.shared.reloadAllTimelines()
            } label: {
                Text("Add")
                    .foregroundColor(.black)
                    .bold()
                    .frame(width: 150, height: 20)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 0.5)
            }
            .disabled(newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            Spacer(minLength: 8)
        }
        .padding(.bottom, 16)
        .background(Color(.systemGray6))
        .presentationDetents([.fraction(0.35)])
    }
}

#Preview {
    AddShoppingItemView(isPresented: .constant(true), shoppingList: .constant(["Milk", "Bread"]))
}
