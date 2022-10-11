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
        // return  Calendar.current.dateComponents([.day], from: self, to: other).day == 0
        return isEqual(to: other, toGranularity: .day)
    }

    
    func isEqual(to other: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: other, toGranularity: component)
    }
    
    // TODO: review this with tests
    func isToday() -> Bool {
        isSameDay(other: Date())
    }
    
    // TODO: review this with tests
    func isThisWeek() -> Bool {
        return  Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear == 0
    }
    
    // Sunday is 1
    func dayOfTheWeek() -> Weekday? {
        let day = Calendar(identifier: .gregorian)
                    .component(.weekday, from: self)
        return Weekday.fromNumber(day)
    }
    
}
/*
 func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
         calendar.isDate(self, equalTo: date, toGranularity: component)
     }

     func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
     func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
     func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

     func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

     var isInThisYear:  Bool { isInSameYear(as: Date()) }
     var isInThisMonth: Bool { isInSameMonth(as: Date()) }
     var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

     var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
     var isInToday:     Bool { Calendar.current.isDateInToday(self) }
     var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

     var isInTheFuture: Bool { self > Date() }
     var isInThePast:   Bool { self < Date() }
 */


