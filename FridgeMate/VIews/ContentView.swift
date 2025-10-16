//
//  ContentView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 15/10/2025.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
        ZStack {
            Color("DarkGreen")
                .ignoresSafeArea()
            
            
            VStack(spacing: 25) {
                // APP名字
                Image("App_Title")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                
                // 插图
                Image("FirstFridge")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)
                
                // 标语
                Text("Simplify food management, Simplify your life")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                
                
                // 开始按钮
                NavigationLink(destination: RootView()) {
                    Text("Get Started")
                        .font(.system(size: 25, weight: .semibold))
                        .frame(width: 200, height: 40)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("ButtonDarkGreen"))
                        .cornerRadius(20)
                        .shadow(radius: 1)
                    
                }

            }
            }
        }
    }
}

#Preview {
    ContentView()
}
