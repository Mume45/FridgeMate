//
//  ScannerView.swift
//  FridgeMate
//
//  Created by 顾诗潆
//

import SwiftUI
import PhotosUI
import AVFoundation

// —— 如果你的项目已有 ScanStore / IngredientRow / ScannedStripView，直接用这份替换 ScannerView.swift —— //
struct ScannerView: View {
    @StateObject private var store = ScanStore()

    // PhotosPicker 选择项
    @State private var selectedPhoto: PhotosPickerItem?

    // 相机
    @State private var showCamera = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if !store.scans.isEmpty {
                    ScannedStripView(items: store.scans)
                        .padding(.vertical, 8)
                }

                List {
                    ForEach($store.scans) { $item in
                        IngredientRow(item: $item)
                    }
                }
                .listStyle(.plain)

                VStack(spacing: 12) {
                    // ✅ 相册：使用 SwiftUI 原生 PhotosPicker（最稳）
                    PhotosPicker(selection: $selectedPhoto,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Label("Choose from Album", systemImage: "photo.on.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    // ✅ 相机（真机）：用 UIKit 封装；无相机自动回退到相册
                    Button {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            showCamera = true
                        } else {
                            // 模拟器等无相机 → 引导使用相册
                            // 也可弹提示
                            print("No camera available; please use album.")
                        }
                    } label: {
                        Label("Take Photo", systemImage: "camera.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        store.scans.removeAll()
                    } label: {
                        Label("Clear", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .navigationTitle("Fridge Scanner")
        }
        // ✅ 监听相册选择结果（异步取出 UIImage）
        .onChange(of: selectedPhoto) { newItem in
            guard let item = newItem else { return }
            Task {
                do {
                    if let data = try await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        store.append(image: image)
                        print("✅ Album image:", image.size)
                    } else {
                        print("⚠️ Failed to load image data from PhotosPicker item.")
                    }
                } catch {
                    print("❌ PhotosPicker load error:", error.localizedDescription)
                }
            }
        }
        // ✅ 相机弹窗
        .sheet(isPresented: $showCamera) {
            CameraSheet { image in
                store.append(image: image)
                print("✅ Camera image:", image.size)
            }
        }
    }
}

// MARK: - 相机封装（UIImagePickerController）
private struct CameraSheet: UIViewControllerRepresentable {
    let onImage: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraSheet
        init(_ parent: CameraSheet) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let img = info[.originalImage] as? UIImage {
                parent.onImage(img)
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
