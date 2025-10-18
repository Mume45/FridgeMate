//
//  FridgeMateWidgetLiveActivity.swift
//  FridgeMateWidget
//
//  Created by 袁钟盈 on 2025/10/18.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FridgeMateWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FridgeMateWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FridgeMateWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension FridgeMateWidgetAttributes {
    fileprivate static var preview: FridgeMateWidgetAttributes {
        FridgeMateWidgetAttributes(name: "World")
    }
}

extension FridgeMateWidgetAttributes.ContentState {
    fileprivate static var smiley: FridgeMateWidgetAttributes.ContentState {
        FridgeMateWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FridgeMateWidgetAttributes.ContentState {
         FridgeMateWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FridgeMateWidgetAttributes.preview) {
   FridgeMateWidgetLiveActivity()
} contentStates: {
    FridgeMateWidgetAttributes.ContentState.smiley
    FridgeMateWidgetAttributes.ContentState.starEyes
}
