//
//  NewHabitViewModel.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2020. 12. 14..
//

import Foundation
import Combine
import Bow


//// Useful:
////  - Must read: https://stackoverflow.com/questions/61855811/using-urlsession-to-load-json-data-for-swiftui-views/61858358#61858358
////   - https://stackoverflow.com/questions/57842609/best-data-binding-practice-in-combine-swiftui
////   - https://stackoverflow.com/questions/61520841/swift-combine-turn-a-publisher-into-a-read-only-currentvaluesubject
////   - https://stackoverflow.com/questions/56718927/can-you-use-a-publisher-directly-as-an-objectbinding-property-in-swiftui
////   - https://stackoverflow.com/questions/58403338/is-there-an-alternative-to-combines-published-that-signals-a-value-change-afte

enum NewHabitViewState {
    case initial
    case saved
    case error([Error])
}

class NewHabitViewModel: ObservableObject {
    // Input
    @Published var habitName = ""
    @Published var habitDescription = ""
    // Output
    @Published var habitNameMessage = ""
    @Published var habitDescriptionMessage = ""
    @Published var isValidHabit = false
    @Published var state = NewHabitViewState.initial
    
    // Other
    private var habitRespository: HabitRepository
    private var cancellableSet: Set<AnyCancellable> = []
    private var isHabitNameValidPublisher: AnyPublisher<Bool, Never> {
        $habitName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { habitName in
                return habitName.count >= 3
            }
            .eraseToAnyPublisher()
    }
    private var isHabitDescriptionValidPublisher: AnyPublisher<Bool, Never> {
        $habitDescription
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { habitDescription in
                return habitDescription.count >= 3
            }
            .eraseToAnyPublisher()
    }

    
    func save() {
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
        let validatedHabit = HabitFactory().create(name: habitName, description: habitDescription)
        validatedHabit.fold(
                        {error in
                            state = NewHabitViewState.error(error)
                        },
                        {habit in
                            habitRespository.habits.append(habit)
                            state = NewHabitViewState.saved
                        })
        
        print("Validating user name: \(habitName) \(validatedHabit) \(state)")
    }
  
  
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest(isHabitNameValidPublisher, isHabitDescriptionValidPublisher)
            .map { isHabitNameValid, isHabitDescriptionValid in
                return isHabitNameValid && isHabitDescriptionValid
            }
            .eraseToAnyPublisher()
    }
  
    
    init(habitRepository:HabitRepository) {
        self.habitRespository = habitRepository
        isHabitNameValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Habit name must at least have 3 characters"
            }
            .assign(to: \.habitNameMessage, on: self)
            .store(in: &cancellableSet)
    
        isHabitDescriptionValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Habit description must at least have 3 characters"
            }
            .assign(to: \.habitDescriptionMessage, on: self)
          . store(in: &cancellableSet)

        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValidHabit, on: self)
            .store(in: &cancellableSet)
    }

}


