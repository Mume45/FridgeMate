//
//  ManualAddView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 16/10/2025.
//

import SwiftUI

struct ManualAddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var itemName = ""
    @State private var amount = ""
    @State private var expirationDate = Date()
    
    var body: some View {
        
        // 顶部标题和关闭按钮
        VStack(spacing: 20) {
            ZStack {
                Text("Add Food")
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
            
            // 输入区域
            VStack(spacing: 15) {
                TextField("Name", text: $itemName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)

                TextField("Amount (number)", text: $amount)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)

                DatePicker("Expiration Date:", selection: $expirationDate, displayedComponents: .date)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            
            // 保存/添加 按钮
            Button(action: {
                // TODO: 保存到库存逻辑
                print("Add item: \(itemName), \(amount), \(expirationDate)")
                dismiss()
            }) {
                HStack {
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundColor(.orange)
                    Text("Add to Inventory")
                        .foregroundColor(.black)
                        .bold()
                }
                .frame(width: 200, height: 30)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 1)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .background(Color(.systemGray6))
        .presentationDetents([.medium]) // 控制底部弹窗高度
        
    }
}

#Preview {
    ManualAddView()
}
