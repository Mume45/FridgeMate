//
//  IngredientRow.swift
//  FridgeMate
//
//  Created by 顾诗潆
//
import SwiftUI

struct IngredientRow: View {
    @Binding var item: IngredientItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let img = item.image {
                img
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Rectangle().fill(Color.gray.opacity(0.2)).frame(width: 56, height: 56).cornerRadius(8)
            }
            VStack(alignment: .leading, spacing: 8) {
                TextField("Name", text: $item.name)
                    .font(.headline)
                HStack {
                    Stepper(value: $item.amount, in: 1...99) { Text("Amount: \(item.amount)") }
                }
                DatePicker("Expiration", selection: $item.expiration, displayedComponents: .date)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}
