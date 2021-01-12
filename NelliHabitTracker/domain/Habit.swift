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
    @Published var progress = Progress()
    
    
    @Published var done = false {
        didSet {
            progress.setForToday(done: done)
        }
    }
    
    init(name: String, description: String = "") {
        self.name = name
        self.description = description
    }
}

enum DailyProgress {
    case unknown
    case done
    case missed
}

struct WeekdayProgress {
    var id = UUID()
    let day: Weekday
    let progress: DailyProgress
    
    init(day: Weekday) {
        self.day = day
        self.progress = day.beforeToday() ? .missed : .unknown
    }
    
    init(day: Weekday, progress: DailyProgress) {
        self.day = day
        self.progress = progress
    }
}

class Progress: ObservableObject {
    private var progress: [Date] = [Date]()
    @Published var weeklyProgress = WeeklyProgress()
    
    func setForToday(done: Bool) {
        weeklyProgress.setForToday(done: done)
        if (done && isTodayMissing()) {
            progress.append(Date())
        } else if (!done && isTodayDone()) {
            progress.removeLast()
        }
    }
    
    private func isTodayMissing() -> Bool {
        if let last = progress.last {
            return !last.isToday()
        }
        return true
    }
    
    private func isTodayDone() -> Bool {
        if let last = progress.last {
            return last.isToday()
        }
        return false
    }
    
}


class WeeklyProgress: ObservableObject {
    @Published var progress = [WeekdayProgress(day:.Sunday),
                               WeekdayProgress(day:.Monday),
                               WeekdayProgress(day:.Tuesday),
                               WeekdayProgress(day:.Wednesday),
                               WeekdayProgress(day:.Thursday),
                               WeekdayProgress(day:.Friday),
                               WeekdayProgress(day:.Saturday)]
    
    func setForToday(done: Bool) {
        let dailyProgress: DailyProgress =  done ? .done : .unknown
        let day = Date().dayOfTheWeek() 
        for (index, weekdayProgress) in progress.enumerated() {
            if case day = weekdayProgress.day {
                progress[index] = WeekdayProgress(day: weekdayProgress.day, progress: dailyProgress)
            }
        }
    }
    
}
