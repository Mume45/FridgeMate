//
//  RecipeView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 15/10/2025.


import SwiftUI

struct RecipesView: View {
    
    // 判断是否选中内置入门菜谱+相应弹窗
    @State private var selectedRecipe: Recipe? = nil
    
    // 判断是否选中用户菜谱的库存对比按钮+相应弹窗
    @State private var selectedUserRecipe: Recipe? = nil
    
    @State private var showAddRecipeSheet = false
    
    // 模拟的入门菜谱数据
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
            imageName: "Pizza"
        )
    ]
    
    // 模拟的用户菜谱数据
    let userRecipes: [Recipe] = [
        Recipe(name: "Fruit Salad", ingredients: ["Apple", "Banana", "Orange"], kind: .user),
        Recipe(name: "Pasta with Cheese", ingredients: ["Pasta", "Cheese", "Garlic"], kind: .user),
        Recipe(name: "Tomato Soup", ingredients: ["Tomato", "Onion", "Salt"], kind: .user)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundGrey")
                    .ignoresSafeArea()
                
                VStack {
                    // 入门菜谱
                    HStack {
                        Text("Beginner Recipes")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(beginnerRecipes) { recipe in
                                BeginnerRecipeCardView(recipe: recipe) {
                                    // 点击卡片弹出详情弹窗
                                    selectedRecipe = recipe
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // 用户菜谱
                    HStack {
                        Text("My Recipes")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    ScrollView {
                        VStack {
                            ForEach(userRecipes) { recipe in
                                // 点击按钮直接弹出库存对比弹窗
                                UserRecipeCardView(recipe: recipe) {
                                    selectedUserRecipe = recipe
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // 添加按钮
                    Button(action: {
                        showAddRecipeSheet = true
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
                    }
                    .padding(.bottom, 80)
                }
            }
            
            // MARK: 弹窗逻辑部分（使用 .sheet(item:)）
            
            // 入门菜谱详情页
            .sheet(item: $selectedRecipe) { recipe in
                BeginnerRecipeDetailView(recipe: recipe)
            }
            
            // 用户菜谱库存对比页
            .sheet(item: $selectedUserRecipe) { recipe in
                InventoryCheckPopupView(recipe: recipe)
            }
            
            // 添加菜谱页
            .sheet(isPresented: $showAddRecipeSheet) {
                AddRecipeView()
            }
        }
    }
}

#Preview {
    RecipesView()
}
