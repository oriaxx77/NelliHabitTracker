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
    @Published var name: String
    var description: String = "Some description"
    var createdAt: Date = Date()
    var doneDates: [Date] = [Date]()
    
    init(id: UUID = UUID(),
         name: String,
         description: String = "",
         createdAt: Date = Date(),
         doneDates: [Date] = [Date]()) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.description = description
        self.doneDates = doneDates
    }
    
    func toggleToday() {
        if (isTodayDone()) {
            doneDates.removeLast()
        } else {
            doneDates.append(Date())
        }
    }
    
    func isTodayDone() -> Bool {
        if let last = doneDates.last {
            return last.isToday()
        }
        return false
    }
    
    
    var habitStatus: HabitStatus = UnknownHabitStatus()
    func dailyStatus() -> HabitStatus {
        return habitStatus
    }
    
    func nextDailyStatus() {
        name = "akarmi"
        habitStatus = habitStatus.nextStatus()
    }
    
}

protocol HabitStatus {
    var color: Color { get }
    func nextStatus() -> HabitStatus
}


class UnknownHabitStatus: ObservableObject, HabitStatus {
    var color: Color = .gray
    func nextStatus() -> HabitStatus {
        ShowedUpHabitStatus()
    }
}

class ShowedUpHabitStatus: ObservableObject, HabitStatus {
    var color: Color = .yellow
    func nextStatus() -> HabitStatus {
        DoneHabitStatus()
    }
}

class DoneHabitStatus: ObservableObject, HabitStatus {
    var color: Color = .green
    func nextStatus() -> HabitStatus {
        MissedHabitStatus()
    }
}

class MissedHabitStatus: ObservableObject, HabitStatus {
    var color: Color = .red
    func nextStatus() -> HabitStatus {
        UnknownHabitStatus()
    }
}


enum DailyStatus {
    case unknown
    case showedUp
    case done
    case missed
}




