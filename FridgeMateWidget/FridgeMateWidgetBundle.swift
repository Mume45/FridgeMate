//
//  FridgeMateWidgetBundle.swift
//  FridgeMateWidget
//
//  Created by 袁钟盈 on 2025/10/18.
//

import WidgetKit
import SwiftUI

@main
struct FridgeMateWidgetBundle: WidgetBundle {
    var body: some Widget {
        FridgeMateWidget()
        FridgeMateWidgetControl()
        FridgeMateWidgetLiveActivity()
    }
}
