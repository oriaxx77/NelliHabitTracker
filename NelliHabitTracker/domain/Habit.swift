//
//  Habit.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2020. 12. 11..
//

import Foundation
import SwiftUI
import Combine

class Habit: ObservableObject, Identifiable {
    var id = UUID()
    var name: String
    var description: String = "Some description"
    var imageName: String = "heart.fill"
    @Published var done = false
    
    init(name: String, description: String = "") {
        self.name = name
        self.description = description
    }

}
