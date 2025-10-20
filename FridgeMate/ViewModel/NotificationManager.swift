//
//  NotificationManager.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 20/10/2025.
//

import Foundation
import UserNotifications

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    
    private init() {
        Task {
            await checkAuthorizationStatus()
        }
    }
    
    // MARK: - 检查通知权限
    func checkAuthorizationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }
    
    // MARK: - 请求通知权限
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            isAuthorized = granted
            return granted
        } catch {
            print("❌ Failed to request notification permission: \(error)")
            return false
        }
    }
    
    // MARK: - 安排过期提醒
    func scheduleExpirationReminders() {
        // 先清除所有旧的提醒
        cancelAllReminders()
        
        // 获取提醒天数设置
        let daysBefore = UserDefaults.standard.integer(forKey: "reminderDaysBefore")
        let days = daysBefore > 0 ? daysBefore : 2 // 默认 2 天
        
        // 获取所有库存
        let items = PantryStore.shared.all()
        let calendar = Calendar.current
        let now = Date()
        
        var scheduledCount = 0
        
        for item in items {
            guard let expirationDate = item.expiration else { continue }
            
            // 跳过已过期的
            if expirationDate < now { continue }
            
            // 计算提醒日期（到期日往前推 N 天）
            guard let reminderDate = calendar.date(byAdding: .day, value: -days, to: expirationDate) else { continue }
            
            // 如果提醒日期已经过了，就不安排了
            if reminderDate < now { continue }
            
            // 创建通知内容
            let content = UNMutableNotificationContent()
            content.title = "⏰ Food Expiring Soon"
            content.body = "\(item.name) will expire in \(days) day(s)"
            content.sound = .default
            content.badge = 1
            
            // 设置触发时间（上午 10:00）
            let triggerDate = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: reminderDate)!
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // 创建请求
            let identifier = "expiry-\(item.id.uuidString)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            // 添加到通知中心
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Failed to schedule notification for \(item.name): \(error)")
                } else {
                    print("✅ Scheduled reminder for \(item.name)")
                }
            }
            
            scheduledCount += 1
        }
        
        print("✅ Scheduled \(scheduledCount) expiration reminders")
    }
    
    // MARK: - 取消所有提醒
    func cancelAllReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("🗑️ Cancelled all pending reminders")
    }
    
    // MARK: - 发送测试通知（3秒后）
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🧪 Test Notification"
        content.body = "This is a test notification from FridgeMate"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "test-notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Test notification failed: \(error)")
            } else {
                print("✅ Test notification will appear in 3 seconds")
            }
        }
    }
    
    // MARK: - 查看待发送的通知（调试用）
    func printPendingNotifications() async {
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        print("📋 Pending notifications: \(requests.count)")
        for request in requests {
            if let trigger = request.trigger as? UNCalendarNotificationTrigger,
               let nextTriggerDate = trigger.nextTriggerDate() {
                print("  - \(request.content.body) at \(nextTriggerDate)")
            }
        }
    }
}
