//
//  AddRecipeView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 18/10/2025.
// - 用户可手动添加菜谱名称与食材列表。
// - TODO: 后期将把用户输入的食材与库存数据进行比对，用于库存检查 (Inventory Comparison)。

import SwiftUI

struct AddRecipeView: View {
    
    @Environment(\.dismiss) var dismiss
    
    // 输入状态
    @State private var recipeName = ""
    @State private var ingredientsText = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
            // 顶部标题 + 关闭按钮
            ZStack {
                Text("Add Your Recipes")
                    .font(.headline)
                    .padding(.top)
                
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding()
                    }
                }
            }
            
            // 输入区域
            VStack(spacing: 15) {
                TextField("Name", text: $recipeName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                
                TextField("Ingredients (separate by commas)", text: $ingredientsText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            // 添加按钮
            Button(action: {
                // TODO: 保存到My Recipes列表逻辑
                print("Add recipe: \(recipeName), ingredients: \(ingredientsText)")
                dismiss()
            }) {
                Text("Add")
                    .foregroundColor(.black)
                    .bold()
                    .frame(width: 200, height: 30)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 1)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding(.top)
        .background(Color(.systemGray6))
        .presentationDetents([.fraction(0.45)]) // 比 medium 稍低，更美观
    }
}

#Preview {
    AddRecipeView()
}
