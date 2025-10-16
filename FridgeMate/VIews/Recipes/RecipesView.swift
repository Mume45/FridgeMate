//
//  RecipeView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 15/10/2025.
//

import SwiftUI

struct RecipesView: View {
    
    // 入门菜谱的虚拟数据
    let beginnerRecipes: [Recipe] = [
        Recipe(
            name: "Tomato Pasta",
            ingredients: ["Tomato", "Pasta", "Garlic"],
            kind: .beginner,
            intro: "A simple and tasty dish for beginners.",
            imageName: "Pizza"
        ),
        Recipe(
            name: "Egg Fried Rice",
            ingredients: ["Rice", "Egg", "Spring Onion"],
            kind: .beginner,
            intro: "Quick and easy fried rice.",
            imageName: "FriedRice"
        )
    ]
    
    // 用户菜谱的虚拟数据
    let userRecipes: [Recipe] = [
        Recipe(name: "Fruit Salad", ingredients: ["Apple", "Banana", "Orange"], kind: .user),
        Recipe(name: "Pasta with Cheese", ingredients: ["Pasta", "Cheese", "Garlic"], kind: .user),
        Recipe(name: "Tomato Soup", ingredients: ["Tomato", "Onion", "Salt"], kind: .user)
    ]


    
    var body: some View {
        NavigationStack {
            ZStack {
                //背景颜色
                Color("BackgroundGrey")
                    .ignoresSafeArea()
                
                VStack {
                    // —— 系统提供的入门菜谱部分 ——
                    // 标题
                    HStack {
                        Text("Beginner Recipes")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // 横向滑动的入门菜谱卡片
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(beginnerRecipes) { recipe in
                                BeginnerRecipeCardView(recipe: recipe)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    

                    
                    // —— 用户自行添加的菜谱部分 ——
                    // 标题
                    HStack {
                        Text("My Recipes")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // 待购食材卡片
                    ScrollView {
                        VStack {
                            ForEach(userRecipes) { recipe in
                                UserRecipeCardView(recipe: recipe) {
                                    // TODO: 实现对比库存弹窗
                                    print("Stock check")
                                }
                            }
                        }
                        .padding(.horizontal)
                        }
                    
                    
                    
                    // Add Recipes 按钮
                    Button(action: {
                        // TODO: 实现添加菜谱功能
                        print("Add Recipe tapped")
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.orange)
                            Text("Add Recipes")
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
        }
    }


#Preview {
    RecipesView()
}
