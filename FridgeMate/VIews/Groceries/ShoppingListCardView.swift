//
//  ShoppingListCardView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 16/10/2025.
//

import SwiftUI

struct ShoppingListCardView: View {
    var itemName: String
    var isChecked: Bool
    var onToggle: () -> Void
    
    var body: some View {
        HStack {
            // 勾选框
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isChecked ?.green : .black)
                .font(.system(size: 20))
                .onTapGesture {
                    onToggle()
                }
            
            // 食材名称部分
            Text(itemName)
                .font(.system(size: 18))
                .foregroundColor(.black)
                .strikethrough(isChecked, color: .black)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        

        
    }
}

#Preview {
    VStack(spacing: 15) {
        ShoppingListCardView(itemName: "Tomatoes", isChecked: false, onToggle: {})
        ShoppingListCardView(itemName: "Eggs", isChecked: true, onToggle: {})
    }
    .padding()
    .background(Color("BackgroundGrey"))
}
