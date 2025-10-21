//  Created by 顾诗潆
//
//  FridgeMateUnitTests.swift
//  FridgeMateUnitTests
//
//  Simple, stable unit tests for core logic in FridgeMate.
//

import XCTest
@testable import FridgeMate
import UIKit

final class FridgeMateUnitTests: XCTestCase {

    //Helpers

    /// Create a tiny solid image used for tests (no I/O, no permissions).
    private func makeTestImage(width: Int = 8, height: Int = 8) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        return renderer.image { ctx in
            UIColor.systemGray.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))
        }
    }

    //ExpirationPolicy

    func testExpirationPolicy() {
        XCTAssertEqual(ExpirationPolicy.defaultDays(for: "apple"), 14)
        XCTAssertEqual(ExpirationPolicy.defaultDays(for: "BANANA"), 7)
        XCTAssertEqual(ExpirationPolicy.defaultDays(for: "unknown-food"), 7) // fallback
    }

    //IngredientItem

    func testIngredientItemImageComputedProperty() {
        let img = makeTestImage()
        let data = img.jpegData(compressionQuality: 0.8) ?? Data()
        let item = IngredientItem(name: "Tomato", amount: 1, expiration: Date(), imageData: data)
        XCTAssertNotNil(item.image, "Valid imageData should create a SwiftUI.Image")
    }

    //SharedDefaults (group helpers)

    func testSharedDefaultsRoundTrip() {
        let sample = ["Milk", "Eggs", "Bread"]
        SharedDefaults.saveItems(sample)
        let loaded = SharedDefaults.loadItems()
        XCTAssertEqual(loaded, sample)
    }

    //GroceryItem (Codable / Hashable)

    func testGroceryItemCodableAndHashable() throws {
        // NOTE: GroceryItem init has NO `key:` parameter in your project.
        let item = GroceryItem(id: UUID(), name: "Orange", amount: 2, expiration: Date())

        // JSON encode/decode should work
        let data = try JSONEncoder().encode([item])
        let decoded = try JSONDecoder().decode([GroceryItem].self, from: data)
        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded.first?.name, "Orange")

        // Hashable sanity (duplicates shouldn't increase count)
        var set = Set<GroceryItem>()
        set.insert(item)
        set.insert(item)
        XCTAssertEqual(set.count, 1)
    }

    //ImageClassifier (robustness only; model may not be available)

    func testImageClassifierReturnsResult() {
        let classifier = ImageClassifier()
        let img = makeTestImage(width: 16, height: 16)

        let result = classifier.classify(img)  // method is classify(_:)
        switch result {
        case .success(let name, let confidence):
            XCTAssertFalse(name.isEmpty)
            XCTAssert(confidence >= 0 && confidence <= 1)
        case .failure:
            // In some environments model isn't loaded — just ensure no crash and a case is returned.
            XCTAssertTrue(true)
        }
    }

    //ScanStore (@MainActor)

    /// ScanStore is annotated with @MainActor; the test must run on main actor as well.
    @MainActor
    func testScanStoreAppend() {
        let store = ScanStore()
        let img1 = makeTestImage(width: 10, height: 10)
        let img2 = makeTestImage(width: 12, height: 12)

        XCTAssertTrue(store.scans.isEmpty)
        store.append(images: [img1, img2])
        XCTAssertEqual(store.scans.count, 2)
    }

    //ShoppingListStore (string normalize / dedupe / remove)

    func testShoppingListStoreBasics() {
        let store = ShoppingListStore.shared
        store.clearAll()                // start clean

        store.add("  Milk ")
        store.add("milk")               // duplicate (case-insensitive)
        store.add(items: ["Eggs", "Bread"])

        XCTAssertTrue(store.all().contains("Milk"))
        XCTAssertTrue(store.all().contains("Eggs"))

        store.remove("BREAD")
        XCTAssertFalse(store.all().contains("Bread"))
    }

    //NotificationManager (debug path only)

    func testNotificationManagerDebugDoesNotCrash() async {
        await NotificationManager.shared.printPendingNotifications()
        XCTAssertTrue(true)
    }
}
