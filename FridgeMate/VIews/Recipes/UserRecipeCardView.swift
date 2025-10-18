//
//  UserRecipeCardView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 16/10/2025.
//
//用户自主添加菜谱

import SwiftUI

struct UserRecipeCardView: View {
    let recipe: Recipe
    var onCheckStock: () -> Void
    var onTapRow: (() -> Void)? = nil
    
    private var ingredientsLine: String {
        "Ingredients: " + recipe.ingredients.joined(separator: ",")
    }
    
    var body: some View {
        VStack {
            HStack {

                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                // 点击文字弹出弹窗
                Button("Check Inventory") {
                    onCheckStock()
                }
                .font(.subheadline)
                .foregroundColor(.green)
                .buttonStyle(.plain)
            }
            
            // 把食材数组显示成一行文字
            HStack {
                Text("Ingredients: \(recipe.ingredients.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            onTapRow?()
        }
    }
}

#Preview {
    UserRecipeCardView(
        recipe: Recipe(
            name: "Fruit Salad",
            ingredients: ["Apple", "Banana", "Orange"],
            kind: .user
        ),
        onCheckStock: {
            print("Show stock check modal here.")
        },
        onTapRow: {
            print("Row tapped - show description.")
        }
    )
    .padding()
}
