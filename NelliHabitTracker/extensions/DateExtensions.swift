//
//  DateExtensions.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2020. 12. 17..
//

import Foundation

public enum Weekday {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    
    func dayNumber() -> Int {
        switch self {
            case .Sunday: return 1
            case .Monday: return 2
            case .Tuesday: return 3
            case .Wednesday: return 4
            case .Thursday: return 5
            case .Friday: return 6
            case .Saturday: return 7
        }
    }
    
    func initial() -> String {
        switch self {
            case .Sunday: return "S"
            case .Monday: return "M"
            case .Tuesday: return "T"
            case .Wednesday: return "W"
            case .Thursday: return "T"
            case .Friday: return "F"
            case .Saturday: return "S"
        }
    }
    
    func before(other: Weekday) -> Bool {
        return self.dayNumber() < other.dayNumber()
    }
    
    func beforeToday() -> Bool {
        guard let dayOfTheWeek = Date().dayOfTheWeek() else {
            return false // TODO: not really true
        }
        return before(other: dayOfTheWeek)
    }
    
    static func fromNumber(_ day:Int) -> Weekday? {
        switch day {
        case 1: return .Sunday
        case 2: return .Monday
        case 3: return .Tuesday
        case 4: return .Wednesday
        case 5: return .Thursday
        case 6: return .Friday
        case 7: return .Saturday
        default: return nil
        }
    }
}

public extension Date {
    func isSameDay(other: Date) -> Bool {
        return  Calendar.current.dateComponents([.day], from: self, to: other).day == 0
    }

    func isToday() -> Bool {
        isSameDay(other: Date())
    }
    
    // Sunday is 1
    func dayOfTheWeek() -> Weekday? {
        let day = Calendar(identifier: .gregorian)
                    .component(.weekday, from: self)
        return Weekday.fromNumber(day)
    }
    
}


