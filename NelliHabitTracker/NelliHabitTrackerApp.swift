//
//  NelliHabitTrackerApp.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2020. 12. 11..
//

import SwiftUI

// See https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app

@main
struct NelliHabitTrackerApp: App {
    // @StateObject var habitRepository = HabitRepository()
    var body: some Scene {
        WindowGroup {
            //HabitsView().environmentObject(Ha)
            HabitsView()
        }
    }
}
