//
//  DataManagementPopupView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 19/10/2025.
//

import SwiftUI

struct DataManagementPopupView: View {
    @Environment(\.dismiss) var dismiss
    
    // 确认弹窗状态
    @State private var showClearInventoryAlert = false
    @State private var showResetAllAlert = false
    
    // 用于显示操作结果
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    
    var body: some View {
        VStack(spacing: 16) {
            
            // 顶部标题和关闭按钮
            ZStack {
                Text("Data Management")
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
            
            Divider()
            
            // 说明文字
            VStack(alignment: .leading, spacing: 8) {
                Text("⚠️ Warning")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.orange)
                
                Text("These actions cannot be undone. Please proceed with caution.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
            
            // 按钮区域
            VStack(spacing: 16) {
                
                // 清空库存
                Button(action: {
                    showClearInventoryAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                        Text("Clear Inventory Data")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 1)
                }
                .alert("Clear Inventory?", isPresented: $showClearInventoryAlert) {
                    Button("Cancel", role: .cancel) {
                        print("🟡 Clear cancelled")
                    }
                    Button("Clear", role: .destructive) {
                        print("🟢 Clear confirmed, executing...")
                        clearInventory()
                    }
                } message: {
                    Text("This will delete all items in your inventory. This action cannot be undone.")
                }
                
                // 重置所有数据
                Button(action: {
                    print("🔵 Reset All button tapped")
                    showResetAllAlert = true
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.red)
                        Text("Reset All App Data")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 1)
                }
                .alert("Reset All Data?", isPresented: $showResetAllAlert) {
                    Button("Cancel", role: .cancel) {
                        print("🟡 Reset cancelled")
                    }
                    Button("Reset", role: .destructive) {
                        print("🟢 Reset confirmed, executing...")
                        resetAllData()
                    }
                } message: {
                    Text("This will delete ALL data including inventory, shopping list, recipes, and settings. This action cannot be undone.")
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .presentationDetents([.fraction(0.45)])
        .onAppear {
            print("📱 DataManagementPopupView appeared")
        }
        .onDisappear {
            print("📱 DataManagementPopupView disappeared")
        }
        // 显示操作结果
        .alert("Success", isPresented: $showResultAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text(resultMessage)
        }
    }
    
    // MARK: - 清空库存
    private func clearInventory() {
        print("🔨 Starting clearInventory()")
        
        // 获取清空前的数量
        let beforeCount = PantryStore.shared.all().count
        print("📊 Items before clear: \(beforeCount)")
        
        // 清空
        PantryStore.shared.clear()
        
        // 获取清空后的数量
        let afterCount = PantryStore.shared.all().count
        print("📊 Items after clear: \(afterCount)")
        
        resultMessage = "Inventory cleared successfully!\n\(beforeCount) items removed."
        showResultAlert = true
        
        print("✅ Inventory cleared successfully")
    }
    
    // MARK: - 重置所有数据
    private func resetAllData() {
        print("🔨 Starting resetAllData()")
        
        var log: [String] = []
        
        // 1. 清空库存
        print("1️⃣ Clearing pantry...")
        let pantryCount = PantryStore.shared.all().count
        PantryStore.shared.clear()
        log.append("Pantry: \(pantryCount) items")
        print("   ✓ Pantry cleared: \(pantryCount) items")
        
        // 2. 清空购物清单
        print("2️⃣ Clearing shopping list...")
        let shoppingList = ShoppingListStore.shared.all()
        let shoppingCount = shoppingList.count
        for item in shoppingList {
            ShoppingListStore.shared.remove(item)
        }
        log.append("Shopping List: \(shoppingCount) items")
        print("   ✓ Shopping list cleared: \(shoppingCount) items")
        
        // 3. 清空用户菜谱
        print("3️⃣ Clearing user recipes...")
        UserDefaults.standard.removeObject(forKey: "user_recipes_v1")
        log.append("User recipes removed")
        print("   ✓ User recipes cleared")
        
        // 4. 重置提醒设置
        print("4️⃣ Resetting reminder settings...")
        UserDefaults.standard.removeObject(forKey: "reminderDaysBefore")
        log.append("Settings reset to default")
        print("   ✓ Reminder settings reset")
        
        // 5. 尝试清空 App Group 数据（如果可用）
        print("5️⃣ Attempting to clear App Group data...")
        if let appGroupDefaults = UserDefaults(suiteName: "group.com.fridgemate.shared") {
            appGroupDefaults.removeObject(forKey: "pantry_items_v3")
            appGroupDefaults.removeObject(forKey: "shopping_list_v1")
            appGroupDefaults.synchronize()
            log.append("App Group data cleared")
            print("   ✓ App Group data cleared")
        } else {
            print("   ⚠️ App Group not accessible (using standard storage)")
            log.append("App Group: not used")
        }
        
        // 6. 取消所有通知
        print("6️⃣ Cancelling all notifications...")
        NotificationManager.shared.cancelAllReminders()
        log.append("All reminders cancelled")
        print("   ✓ Notifications cancelled")
        
        resultMessage = "All data reset!\n\n" + log.joined(separator: "\n")
        showResultAlert = true
        
        print("✅ All app data reset successfully")
        print("📋 Summary:\n" + log.joined(separator: "\n"))
    }
}

#Preview {
    DataManagementPopupView()
}
