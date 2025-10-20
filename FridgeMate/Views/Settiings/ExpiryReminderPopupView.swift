//
//  ExpiryReminderPopupView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 19/10/2025.
//

import SwiftUI

struct ExpiryReminderPopupView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var notificationManager = NotificationManager.shared
    
    // 保存设置值（默认提前2天）
    @AppStorage("reminderDaysBefore") var reminderDaysBefore: Int = 2
    
    // 控制弹窗
    @State private var showPermissionAlert = false
    @State private var showSuccessMessage = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            // 顶部标题和关闭按钮
            ZStack {
                Text("Expiry Reminder Settings")
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
            
            // 通知权限状态
            if !notificationManager.isAuthorized {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "bell.slash.fill")
                            .foregroundColor(.orange)
                        Text("Notifications Disabled")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                    }
                    
                    Text("Please enable notifications to receive expiry reminders.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        Task {
                            let granted = await notificationManager.requestAuthorization()
                            if granted {
                                notificationManager.scheduleExpirationReminders()
                                showSuccessMessage = true
                            } else {
                                showPermissionAlert = true
                            }
                        }
                    }) {
                        Text("Enable Notifications")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
            }
            
            VStack(spacing: 10) {
                
                // 当前提醒设置
                HStack {
                    Text("Remind me")
                    Text("\(reminderDaysBefore)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.green)
                    Text("day(s) before")

                    Spacer()

                    Stepper("", value: $reminderDaysBefore, in: 1...10)
                        .labelsHidden()
                        .onChange(of: reminderDaysBefore) { _ in
                            // 设置改变时重新安排提醒
                            if notificationManager.isAuthorized {
                                notificationManager.scheduleExpirationReminders()
                                showSuccessMessage = true
                            }
                        }
                }
                .padding()
                
                // 提示语
                Text("Set a reminder 1 to 10 days before food expiry.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // 成功提示
                if showSuccessMessage {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Reminders updated!")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                    .padding(.top, 4)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSuccessMessage = false
                            }
                        }
                    }
                }
            }
            
            // 测试按钮（仅调试时显示）
            #if DEBUG
            VStack(spacing: 8) {
                Button("🧪 Test Notification (3s)") {
                    notificationManager.sendTestNotification()
                }
                .font(.caption)
                .foregroundColor(.blue)
                
                Button("📋 Show Pending Notifications") {
                    Task {
                        await notificationManager.printPendingNotifications()
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(.top, 8)
            #endif
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .presentationDetents([.fraction(0.45)])
        .task {
            // 页面加载时检查权限
            await notificationManager.checkAuthorizationStatus()
            // 如果已授权，安排提醒
            if notificationManager.isAuthorized {
                notificationManager.scheduleExpirationReminders()
            }
        }
        .alert("Permission Required", isPresented: $showPermissionAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please enable notifications in Settings to receive expiry reminders.")
        }
    }
}

#Preview {
    ExpiryReminderPopupView()
}
