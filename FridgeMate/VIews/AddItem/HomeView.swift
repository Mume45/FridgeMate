//
//  HomeView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 15/10/2025.
//

import SwiftUI

struct HomeView: View {
    // 点击手动添加弹出弹窗
    @State private var showManualAdd = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                //背景颜色
                Color("BackgroundGrey")
                    .ignoresSafeArea()
                
                VStack {
                    // 顶部标题（靠左）
                    HStack {
                        Text("Fridge Scanner")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // 中间冰箱图片
                    Image("Bigfridge")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)
                    
                    // 注释文字
                    Text("Click and start manage your Fridge!")
                        .font(.body)
                        .foregroundColor(.gray)
                    //.multilineTextAlignment(.center)
                    //.padding(.horizontal)
                    
                    Spacer()
                    
                    // 按钮区域
                    HStack (spacing: 20) {
                        // 照片识别按钮
                        Button (action: {
                            // TODO: 打开相机识别功能
                            print("Photo button tapped")
                        }) {
                            HStack {
                                Image(systemName: "camera")
                                    .foregroundColor(.black)
                                Text("Photo")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                        
                        // 手动添加按钮
                        Button (action: {
                            showManualAdd = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .foregroundColor(.black)
                                Text("Manual Add")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                        .sheet(isPresented: $showManualAdd) {
                            ManualAddView()
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                }
            }
            
            
        }
    }
}

#Preview {
    HomeView()
}
