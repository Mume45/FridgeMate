//
//  ContentView.swift
//  FridgeMate
//
//  Created by 孙雨晗 on 15/10/2025.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
        ZStack {

            Image("Splash_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
            }
            /*
            VStack {
                // Add spacing to move title downward
                Spacer().frame(height: 200)
                
                // App title
                Image("APPTitle")
                    .resizable()
                    .scaledToFit()
                    .frame(width:280)

                Spacer()
                
                // Navigation button: tap to enter WeatherView
                NavigationLink(destination: WeatherView()) {
                    Image("StartButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width:150)
                }
                
                Spacer().frame(height: 90)
            }*/
            }
        }
    }
}

#Preview {
    ContentView()
}
