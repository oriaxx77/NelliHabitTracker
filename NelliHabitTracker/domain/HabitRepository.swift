//
//  HabitRepository.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2020. 12. 14..
//

import Foundation
import Combine

enum RepositoryError: Error {
    case notUnique
}

class HabitRepository: ObservableObject {
    
    @Published var habits = [
        Habit(name:"Yoga"),
        Habit(name:"Smoothie"),
        Habit(name:"Spanish duolingo")
    ]
    
    static var shared = HabitRepository()
    
//    func all() -> AnyPublisher<[Habit],Never> {
//        return Just(habits)
//                .eraseToAnyPublisher()
//    }
//
//    func save(habit: Habit) -> AnyPublisher<Bool,Never> {
//        Just(habit)
//            .map{ habits.append($0); return true }
//            .eraseToAnyPublisher()
//
//    }
}

/*
 func userNameAvailable(_ username: String) -> AnyPublisher<Validated<SignUpError,String>,Never> {
     /*
     func usernameAvailable(_ username: String, completion: @escaping (Bool) -> ()) -> () {
       DispatchQueue.main .async {
         if (username == "foobar") {
           completion(true)
         } else {
           completion(false)
         }
       }
     }
     */
     
     let validatedUserName = username == "oriaxx77" ? Validated.valid(username) : Validated.invalid(SignUpError.usernameNotAvailable)
     print("Validating user name: \(username) \(validatedUserName)")
     return Just(validatedUserName).eraseToAnyPublisher()
 }
 */
