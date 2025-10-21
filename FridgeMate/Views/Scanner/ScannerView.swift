//
//  ScannerView.swift
//  FridgeMate
//
//  Created by 顾诗潆
//

import SwiftUI

struct ScannerView: View {
    @StateObject private var store = ScanStore()
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
                HStack(spacing: 12) {
                    Button {
                        showCamera = true
                    } label: {
                        Label("打开相机", systemImage: "camera.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    PhotoPicker { imgs in
                        store.append(images: imgs)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .navigationTitle("食材扫描")
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker { img in
                if let img { store.append(image: img) }
            }
            .ignoresSafeArea()
        }
    }
}
