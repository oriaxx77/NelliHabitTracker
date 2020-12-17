//
//  HabitBuilder.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2020. 12. 15..
//

import Foundation
import Bow

enum HabitError: Error {
    case emptyNameError
    case emptyDescriptionError
}

class HabitFactory {
    
    func create(name: String, description: String) -> Validated<[Error],Habit> {
        var errors = [HabitError]()
        
        if (name.isEmpty) {
            errors.append(.emptyNameError)
        }
        
        if (description.isEmpty) {
            errors.append(.emptyDescriptionError)
        }
        
        return errors.isEmpty ?
                Validated.valid(Habit(name: name)) :
                Validated.invalid(errors)
    }
    
    func createInvalid() -> Validated<[HabitError],Habit> {
        let errors: [HabitError] = [.emptyNameError, .emptyDescriptionError]
        return Validated.invalid(errors)
    }
    
}
