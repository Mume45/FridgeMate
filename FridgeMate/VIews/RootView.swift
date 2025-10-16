//
//  RootView.swift
//  FridgeMate
//
//  底部导航栏结构
//

import SwiftUI

struct RootView: View {
    
    init() {
            // 自定义 TabBar 外观
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "BarGreen") // 你在 Assets 里自定义的颜色名
        

            // 改变未选中图标和文字颜色
            appearance.stackedLayoutAppearance.normal.iconColor = .white.withAlphaComponent(0.6)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.6)]

            // 改变选中图标和文字颜色
            appearance.stackedLayoutAppearance.selected.iconColor = .white
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]

            // 应用外观
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem{
                    Label ("Scan", systemImage: "camera.viewfinder")
                }
            
            GroceriesView()
                .tabItem{
                    Label ("Groceries", systemImage: "list.bullet.clipboard")
                }
            
            RecipesView()
                .tabItem {
                    Label ("Recipes", systemImage: "book")
                }
            
            
            SettingsView()
                .tabItem {
                    Label ("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    RootView()
}
