//
//  NelliHabitTrackerApp.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2020. 12. 11..
//

import SwiftUI
import CoreData

// See https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app

@main
struct NelliHabitTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            HabitsView()
        }
    }
}
