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
    @State private var descriptionText = ""
    @State private var ingredientsText = ""
 
    
    // 解析后食材预览
    private var parsedIntegradients: [String] {
        ingredientsText
            .split(separator: ",")
            .map{ $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter{!$0.isEmpty}
    }
    
    // 校验名称和食材为必填
    private var canSubmit: Bool {
        !recipeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !parsedIntegradients.isEmpty
    }
    
    
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
                Text("Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("e.g., Tomato Pasta", text: $recipeName)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
            
            // Description
            VStack(alignment: .leading, spacing: 6) {
                Text("Description (optional)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $descriptionText)
                        .frame(minHeight: 110, maxHeight: 150)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    if descriptionText.isEmpty {
                        Text("Write a short intro or chooking notes...")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .allowsHitTesting(false)
                    }
                }
            }
            
            //Ingredients
            VStack(alignment: .leading, spacing: 8) {
                Text("Ingredients (separate by commas)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("e.g., Tomato, Pasta, Garlic", text: $ingredientsText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                
                if !parsedIntegradients.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(parsedIntegradients, id: \.self) { ing in
                                
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            
            // 添加按钮
            Button(action: {
                            
                let trimmedName = recipeName.trimmingCharacters(in: .whitespacesAndNewlines)
                print("Add recipe: \(trimmedName)")
                print("Description: \(descriptionText)")
                print("Ingredients: \(parsedIntegradients)")
                dismiss()
            }) {
                Text("Add")
                    .foregroundColor(.black)
                    .bold()
                    .frame(width: 200, height: 30)
                    .padding()
                    .background(Color.white.opacity(canSubmit ? 1 : 0.6))
                    .cornerRadius(12)
                    .shadow(radius: 1)
                }
                .disabled(!canSubmit)
                .padding(.top, 6)

                Spacer(minLength: 6)
            }
            .padding(.top)
            .background(Color(.systemGray6))
            .presentationDetents([.fraction(0.6), .large])
        }
    }
                
                
                
                
#Preview {
    AddRecipeView()
}
