//
//  PhotoOptionPopupView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 18/10/2025.
//

import SwiftUI

struct PhotoOptionPopupView: View {
    @Environment(\.dismiss) var dismiss
    
    // MARK: 回调函数（暂时默认空实现，便于预览）
    var onSelectAlbum: () -> Void = {}
    var onSelectCamera: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 16) {
            
            ZStack {
                Text("Select Image Source")
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
            
            // 从相册选择
            Button(action: {
                print("Album selected")  // TODO: connect to onSelectAlbum() later
                // Example:
                // dismiss()
                // onSelectAlbum()
            }) {
                Text("Choose from Album")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
            }
            
            // 相机
            Button(action: {
                print("Camera selected") // TODO: connect to onSelectCamera() later
                // Example:
                // dismiss()
                // onSelectCamera()
            }) {
                Text("Take Photo")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .presentationDetents([.fraction(0.3)]) // 控制底部弹窗高度
    }
}

#Preview {
    PhotoOptionPopupView()
}
