//
//  PhotoPicker.swift
//  FridgeMate
//
//  Created by 顾诗潆
//
import SwiftUI
import PhotosUI

struct PhotoPicker: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    var onImages: ([UIImage]) -> Void

    var body: some View {
        PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
            Label("从相册选择", systemImage: "photo.on.rectangle.angled")
        }
        .onChange(of: selectedItems) { _, items in
            Task {
                var images: [UIImage] = []
                for item in items {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let img = UIImage(data: data) {
                        images.append(img)
                    }
                }
                selectedItems.removeAll()
                onImages(images)
            }
        }
    }
}
