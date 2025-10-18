//
//  BeginnerRecipeDetailView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 17/10/2025.
// 在菜单页面点击上方入门菜单（系统内置）的图片后，会弹出菜单详情弹窗



import SwiftUI

struct BeginnerRecipeDetailView: View {
    var recipe: Recipe
    
    @Environment(\.dismiss) var dismiss
    @State private var showInventoryCheck = false
    
    @State private var inventoryDetent: PresentationDetent = .large
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            // 顶部标题和关闭按钮
            ZStack {
                Text(recipe.name)
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
                
                // 菜谱内容区域
                HStack(alignment: .top, spacing: 10) {
                    // 左侧图片
                    Image(recipe.imageName ?? "DefaultImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 120)
                        .cornerRadius(12)
                    
                    // 右侧描述
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descriptions:")
                            .font(.subheadline)
                        //.foregroundColor(.secondary)
                        
                        // 简介（intro是可选类型 String?，需要提供默认值）
                        Text(recipe.intro ?? "No description available")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 4)
                    
                    Spacer()
                }
                
                // 食材列表
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ingredients:")
                        .font(.headline)
                    Text(recipe.ingredients.joined(separator: ", "))
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
                
                // 检查库存按钮
                Button(action: {
                    showInventoryCheck = true
                }) {
                    Text("Check Inventory")
                        .foregroundColor(.black)
                        .bold()
                        .frame(width: 150, height: 30)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 1)
                }
                
                Spacer()
                
            }
            .padding(.top)
            .background(Color(.systemGray6))
            .presentationDetents([.medium])
            
            .sheet(isPresented: $showInventoryCheck) {
                InventoryCheckPopupView(recipe: recipe)
                    .presentationDetents([.medium, .large], selection: $inventoryDetent)
                    .onAppear{ inventoryDetent = .large}
        }
    }
}

#Preview {
    BeginnerRecipeDetailView(
        recipe: Recipe(
            name: "Test Dish",
            ingredients: ["Apple", "Banana", "Egg", "Banana", "Egg", "Banana", "Egg", "Banana"],
            kind: .beginner,
            intro: "Just for preview",
            imageName: "Pizza"
    )
 )
}
