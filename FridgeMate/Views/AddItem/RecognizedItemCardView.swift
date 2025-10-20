//
//  RecognizedItemCardView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 20/10/2025.
//  MARK: 识别出来的食物的展示页面

import SwiftUI

struct RecognizedItemCardView: View {
    
    var isChecked: Bool
    var onToggle: () -> Void
    
    var name: String
    var amount: String
    var expiration: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(name)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? .green : .black)
                    .font(.system(size: 20))
                    .onTapGesture { onToggle() }
            }
            
            Text("Amount: \(amount)")
            Text("Expiration Date: \(expiration)")
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    RecognizedItemCardView(
        isChecked: true,
        onToggle: {},
        name: "Tomatoes",
        amount: "2",
        expiration: "2025/10/20"
    )
}
