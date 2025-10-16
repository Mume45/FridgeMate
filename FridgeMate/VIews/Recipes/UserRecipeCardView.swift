//
//  UserRecipeCardView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 16/10/2025.
//

import SwiftUI

struct UserRecipeCardView: View {
    let recipe: Recipe
    var onCheckStock: () -> Void
    
    var body: some View {
        VStack {
            HStack {

                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("Check Stocks") {
                    onCheckStock()
                }
                .font(.subheadline)
                .foregroundColor(.green)
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
        }
    )
    .padding()
}
