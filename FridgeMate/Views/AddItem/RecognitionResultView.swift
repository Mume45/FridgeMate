//
//  RecognitionResultView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 18/10/2025.
// - 识别结果页面：显示用户选择的图片、识别出的食材，以及添加选项
// - 未完成，同时这页识别出来的食材应该可以修改信息，目前UI还没有这部分

import SwiftUI

struct RecognitionResultView: View {
    @Environment(\.dismiss) var dismiss
    
    // 示例数据
    let recognizedItems = ["Tomato", "Egg", "Milk", "Cheese"]
    let capturedImages = ["food1", "food1", "food1"] // 示例图片名称
    
    var body: some View {
        ZStack {
            // 背景色
            Color("BackgroundGrey")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // 标题栏
                HStack {
                    Text("Fridge Scanner")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // MARK: 已识别图片 - 目前用的是虚拟数据（横向滚动）
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(capturedImages, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 180, height: 120)
                                .clipped()
                                .cornerRadius(12)
                                .shadow(radius: 3)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                HStack {
                    Text("Recognition Result")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
                
                // MARK: 识别出的食材（竖向滚动）
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(recognizedItems, id: \.self) { item in
                            HStack {
                                Text(item)
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "cart.badge.plus")
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 1)
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
                
                // MARK: 底部按钮
                VStack(spacing: 12) {
                    Button(action: {
                        // 加入库存逻辑
                    }) {
                        Text("Add to Inventory")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            // 重新扫描
                        }) {
                            Text("Rescan")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            // 手动添加
                        }) {
                            Text("Manual Input")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}
#Preview {
    RecognitionResultView()
}
