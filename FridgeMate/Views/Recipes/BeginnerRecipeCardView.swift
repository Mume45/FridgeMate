//
//  BeginnerRecipeCardView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 16/10/2025.
//

import SwiftUI

struct BeginnerRecipeCardView: View {
    let recipe: Recipe
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            VStack {
                if let imageName = recipe.imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 120)
                        .clipped()
                        .cornerRadius(12)
                }

                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .lineLimit(1)
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 2)
        }
    }
}

#Preview {
    BeginnerRecipeCardView(recipe: Recipe(
        name: "Tomato Pasta",
        ingredients: ["Tomato", "Pasta", "Garlic"],
        kind: .beginner,
        intro: "A simple and tasty dish for beginners.",
        imageName: "Pizza"
        ),
        onTap: {}
    )
}
