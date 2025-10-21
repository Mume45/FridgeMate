//
//  ScanStore.swift
//  FridgeMate
//
//  Created by 顾诗潆
//
import Foundation
import UIKit

@MainActor
final class ScanStore: ObservableObject {
    @Published var scans: [IngredientItem] = []
    private let classifier = ImageClassifier()

    func append(images: [UIImage]) {
        for img in images {
            let r = classifier.classify(img)
            let name: String
            switch r {
            case .success(let id, _):
                name = id.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? id
            case .failure:
                name = "Unknown"
            }
            let days = ExpirationPolicy.defaultDays(for: name)
            let data = img.jpegData(compressionQuality: 0.8) ?? Data()
            let item = IngredientItem(name: name, amount: 1, expiration: Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date(), imageData: data)
            scans.append(item)
        }
    }

    func append(image: UIImage) {
        append(images: [image])
    }
}
