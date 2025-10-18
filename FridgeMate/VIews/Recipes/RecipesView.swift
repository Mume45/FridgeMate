//
//  RecipeView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 15/10/2025.

// 加入了数据保存
// 左滑可以删除菜谱

import SwiftUI

struct RecipesView: View {
    
    // 是否选中内置入门菜谱+相应弹窗
    @State private var selectedRecipe: Recipe? = nil
    
    // 判断是否选中用户菜谱的库存对比按钮+相应弹窗
    @State private var selectedUserRecipe: Recipe? = nil
    
    // 添加菜谱弹窗
    @State private var showAddRecipeSheet = false
    
    //查看描述
    @State private var viewingIntroRecipe: Recipe? = nil
    @State private var inventoryDetent: PresentationDetent = .large
    
    //待删除的菜谱
    @State private var recipeToDelete: Recipe? = nil
    
  
    private let userRecipesKey = "user_recipes_v1"
    private let defaultUserRecipes: [Recipe] = [
        Recipe(name: "Fruit Salad", ingredients: ["Apple", "Banana", "Orange"], kind: .user),
        Recipe(name: "Pasta with Cheese", ingredients: ["Pasta", "Cheese", "Garlic"], kind: .user),
        Recipe(name: "Tomato Soup", ingredients: ["Tomato", "Onion", "Salt"], kind: .user)
    ]
    
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
            imageName: "egg fried rice"
        ),
        
        Recipe(
            name:"Chicken Salad",
            ingredients: ["Chicken", "lettuce", "Tomato", "Cucumber"],
            kind: .beginner,
            intro: "Light and refreshing salad with lean protein.",
            imageName: "chicken salad"
        ),
        
        Recipe(
            name: "Beef Stri Fry",
            ingredients: ["Beef", "Bell Pepper", "Onion", "Soy Sauce"],
            kind: .beginner,
            intro: "Fast weekday stri fry with tender beef.",
            imageName: "beef stri fry"
        ),
        
        Recipe(
            name: "Garlic Butter Shrimp",
            ingredients: ["shrimp", "garlic", "Butter", "Parsly"],
            kind: .beginner,
            intro: "Juicy shrimp sauteed in gralic butter.",
            imageName: "butter shrimp"
        ),
        
        Recipe(
            name: "Pancakes",
            ingredients: ["Flour", "Milk", "Egg", "Sugar"],
            kind: .beginner,
            intro: "Fluffy pancakes perfect for breakfast.",
            imageName: "pancake"
        ),
        
        Recipe(
            name: "Avocado Toast",
            ingredients: ["Bread", "Avocodo", "Lemon", "Salt"],
            kind: .beginner,
            intro: "Creamy avacado on crispy toast.",
            imageName: "toast"
        ),
        
    ]
    

    @State private var userRecipes: [Recipe] = []
    
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
                    
                    // 左滑删除；外观通过 list 修饰保持不变
                    List {
                        ForEach(userRecipes) { recipe in
                            UserRecipeCardView(
                                recipe: recipe,
                                onCheckStock: {
                                    selectedUserRecipe = recipe
                                },
                                onTapRow: {
                                    viewingIntroRecipe = recipe
                                }
                            )
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            // 左滑删除
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    recipeToDelete = recipe
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    
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
                    .presentationDetents([.large])
            }

            // 添加菜谱页
            .sheet(isPresented: $showAddRecipeSheet) {
                AddRecipeView { name, desc, ings in
                    let new = Recipe(name: name, ingredients: ings, kind: .user, intro: desc)
                    userRecipes.insert(new, at: 0)
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
            }
            
            .alert(item: $viewingIntroRecipe) { r in
                Alert(
                    title: Text(r.name),
                    message: Text( (r.intro?.isEmpty == false) ? r.intro! : "No description yet."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            //删除
            .alert(item: $recipeToDelete) { r in
                Alert(
                    title: Text("Delete “\(r.name)” ?"),
                    message: Text("This cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let idx = userRecipes.firstIndex(where: { $0.id == r.id }) {
                            userRecipes.remove(at: idx)   
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            
            // 数据保存
            .onAppear {
                loadUserRecipes()
            }
            .onChange(of: userRecipes) { _ in
                saveUserRecipes()
            }
        }
    }
}

private extension RecipesView {
    func loadUserRecipes() {
        let ud = UserDefaults.standard
        if let data = ud.data(forKey: userRecipesKey) {
            do {
                let decoded = try JSONDecoder().decode([Recipe].self, from: data)
                userRecipes = decoded.isEmpty ? defaultUserRecipes : decoded
            } catch {
                userRecipes = defaultUserRecipes
            }
        } else {
            userRecipes = defaultUserRecipes
        }
    }
    
    func saveUserRecipes() {
        do {
            let data = try JSONEncoder().encode(userRecipes)
            UserDefaults.standard.set(data, forKey: userRecipesKey)
        } catch {
            print("Failed to save user recipes: \(error)")
        }
    }
}
