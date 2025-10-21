//
//  ScannedStripView.swift
//  FridgeMate
//
//  Created by 顾诗潆
//
import SwiftUI

struct ScannedStripView: View {
    let items: [IngredientItem]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items) { it in
                    if let img = it.image {
                        img
                            .resizable()
                            .scaledToFill()
                            .frame(width: 72, height: 72)
                            .clipped()
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.separator, lineWidth: 0.5))
                    } else {
                        Rectangle().fill(Color.gray.opacity(0.2)).frame(width: 72, height: 72).cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
