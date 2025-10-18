//
//  AddRecipeView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 18/10/2025.
// - 用户可手动添加菜谱名称与食材列表。
// - TODO: 后期将把用户输入的食材与库存数据进行比对，用于库存检查 (Inventory Comparison)。

import SwiftUI

struct AddRecipeView: View {
    var onSave: (String, String?, [String]) -> Void
    
    @Environment(\.dismiss) private var dismiss

    // 表单状态
    @State private var recipeName = ""
    @State private var descriptionText = ""
    @State private var ingredientsText = ""

    @State private var detent: PresentationDetent = .large

    // 解析后的食材（
    private var parsedIngredients: [String] {
        ingredientsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    // 必填名称和食材
    private var canSubmit: Bool {
        !recipeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !parsedIngredients.isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {

            VStack(spacing: 12) {

                ZStack {
                    Text("Add Your Recipes")
                        .font(.headline)

                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .padding(12)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)

            // 表单
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    // Name
                    SectionHeader("Name")
                    RoundedField {
                        TextField("e.g., Tomato Pasta", text: $recipeName)
                            .textInputAutocapitalization(.words)
                            .disableAutocorrection(true)
                    }

                    // Description
                    SectionHeader("Description (optional)")
                    RoundedEditor(text: $descriptionText,
                                  placeholder: "Write a short intro or cooking notes...")

                    // Ingredients
                    SectionHeader("Ingredients (separate by commas)")
                    RoundedField {
                        TextField("e.g., Tomato, Pasta, Garlic", text: $ingredientsText)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .keyboardType(.default)
                    }

                    // 食材预览
                    if !parsedIngredients.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(parsedIngredients, id: \.self) { ing in
                                    Text(ing)
                                        .font(.subheadline)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color(.systemGray5))
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(.top, 2)
                        }
                    }

                    Spacer(minLength: 12)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }

            // 底部提交按钮
            Button(action: {
                            let name = recipeName.trimmingCharacters(in: .whitespacesAndNewlines)
                            let desc = descriptionText.trimmingCharacters(in: .whitespacesAndNewlines)
                            let ings = parsedIngredients
                            onSave(name, desc.isEmpty ? nil : desc, ings)
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

private struct SectionHeader: View {
    let title: String
    init(_ title: String) { self.title = title }
    var body: some View {
        Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundColor(.secondary)
    }
}

private struct RoundedField<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        content
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

private struct RoundedEditor: View {
    @Binding var text: String
    var placeholder: String

    init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .frame(minHeight: 110, maxHeight: 160)
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)

            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
                    .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    AddRecipeView { _, _, _ in }
}
