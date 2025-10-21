//
//  CameraPicker.swift
//  FridgeMate
//
//  Created by 顾诗潆
//
import SwiftUI
import UIKit

struct CameraPicker: UIViewControllerRepresentable {
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        init(parent: CameraPicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let img = (info[.editedImage] ?? info[.originalImage]) as? UIImage
            picker.dismiss(animated: true) { self.parent.onImage(img) }
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) { self.parent.onImage(nil) }
        }
    }

    var onImage: (UIImage?) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let c = UIImagePickerController()
        c.sourceType = .camera
        c.allowsEditing = true
        c.delegate = context.coordinator
        return c
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
