//
//  ImageClassifier.swift
//  FridgeMate
//
//  Created by 顾诗潆
//
import Foundation
import Vision
import CoreML
import UIKit

final class ImageClassifier {
    enum Result {
        case success(String, Double)
        case failure
    }

    private let vnModel: VNCoreMLModel?

    init() {
        vnModel = try? VNCoreMLModel(for: MobileNetV2FP16(configuration: MLModelConfiguration()).model)
    }

    func classify(_ image: UIImage) -> Result {
        guard let vnModel else { return .failure }
        guard let ci = CIImage(image: image) else { return .failure }
        let request = VNCoreMLRequest(model: vnModel)
        let handler = VNImageRequestHandler(ciImage: ci, options: [:])
        do {
            try handler.perform([request])
            guard let results = request.results as? [VNClassificationObservation],
                  let best = results.first else { return .failure }
            return .success(best.identifier, Double(best.confidence))
        } catch {
            return .failure
        }
    }
}
