//
//  SettingsView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 15/10/2025.
//

import SwiftUI

struct SettingsView: View {
    
    // 控制弹窗显示
    @State private var showReminderSheet = false
        @State private var showDataManagementSheet = false
        
        var body: some View {

                ZStack {
                    Color("BackgroundGrey")
                        .ignoresSafeArea()
                    
                    VStack {
                        // 页面标题
                        HStack {
                            Text("My Settings")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        // 设置卡片区
                        VStack(spacing: 16) {
                            
                            // MARK: 库存阈值设置
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "timer")
                                        .foregroundColor(.orange)
                                    Text("Inventory Threshold Settings")
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .frame(height: 60)
                            }
                            
                            // MARK: 过期提醒设置
                            Button(action: {
                                showReminderSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "calendar.badge.clock")
                                        .foregroundColor(.orange)
                                    Text("Expiry Reminder Settings")
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .frame(height: 60)
                            }
                            
                            // MARK: 数据管理
                            Button(action: {
                                showDataManagementSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "tray.full.fill")
                                        .foregroundColor(.orange)
                                    Text("Data Management")
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .frame(height: 60)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
                // 弹出过期提醒弹窗
                .sheet(isPresented: $showReminderSheet) {
                    ExpiryReminderPopupView()
                }
                
                .sheet(isPresented: $showDataManagementSheet) {
                    DataManagementPopupView()
            }
        }
    }

    #Preview {
        SettingsView()
    }
