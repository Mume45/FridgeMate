//
//  GroceriesCardView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 16/10/2025.
//

import SwiftUI

struct GroceriesCardView: View {
    var name: String
    var amount: String
    var expiration: String
    var status: String // “Fresh”, “Soon to Expire”, “Out of date”
    var color: Color
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(name)
                    .font(.headline)
                
                Spacer()
                
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                Text(status)
                    .foregroundColor(.gray)
                
            }
            Text("Amounts: \(amount)")
            Text("Expiration Date: \(expiration)")
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        
    }

}

#Preview {
    GroceriesCardView(
        name: "Tomatoes",
        amount: "2",
        expiration: "2025/10/20",
        status: "Soon to Expire",
        color: .orange
    )
}
