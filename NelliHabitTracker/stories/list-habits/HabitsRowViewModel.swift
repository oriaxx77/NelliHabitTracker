//
//  HabitsRowViewModel.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2021. 01. 28..
//

import Foundation
import SwiftUI




class HabitRowViewModel: ObservableObject {
    @Published var habit: Habit
    @Published var weeklyProgress: WeeklyProgress // TODO: make it private(set)
    private let habitRepository = HabitRepository.shared
    private var rename = false
    @Published var name = "kiskutya"
    
    init(habit: Habit) {
        self.habit = habit
        weeklyProgress = WeeklyProgress(habit.doneDates)
    }
    
    // TODO: refactor this according to Option 2 here
    // https://stackoverflow.com/questions/58203531/an-equivalent-to-computed-properties-using-published-in-swift-combine
    func toggleToday() {
        habit.toggleToday()
        weeklyProgress = WeeklyProgress(habit.doneDates)
        habitRepository.update(habit)
    }
    
    func nextStatus() {
        print("next status called")
        //habit.name = "mila"
        rename = !rename
        habit.name =  (rename ? "mila": "mozart")
    }
    
    func deleteHabit() {
        habitRepository.delete(habit)
    }
    
    func color() -> Color {
        return habit.habitStatus.color
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
    
    init(_ doneDates: [Date]) {
        doneDates
            .filter { $0.isThisWeek() }
            .forEach { setDone(date: $0) }
    }
    
    func setForToday(done: Bool) {
        let dailyProgress: DailyStatus =  done ? .done : .unknown
        let day = Date().dayOfTheWeek()
        for (index, weekdayProgress) in progress.enumerated() {
            if case day = weekdayProgress.day {
                progress[index] = WeekdayProgress(day: weekdayProgress.day, progress: dailyProgress)
            }
        }
    }
    
    private func setDone(date: Date) {
        // TODO: check this week
        for (index, weekdayProgress) in progress.enumerated() {
            if case date.dayOfTheWeek() = weekdayProgress.day {
                progress[index] = WeekdayProgress(day: weekdayProgress.day, progress: .done)
            }
        }
    }
    
}


struct WeekdayProgress {
    var id = UUID()
    let day: Weekday
    let progress: DailyStatus
    
    init(day: Weekday) {
        self.day = day
        self.progress = day.beforeToday() ? .missed : .unknown
    }
    
    init(day: Weekday, progress: DailyStatus) {
        self.day = day
        self.progress = progress
    }
}

