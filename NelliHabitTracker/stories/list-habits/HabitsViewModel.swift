//
//  HabitsViewModel.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2021. 01. 14..
//

import Foundation
import Combine

class HabitsViewModel: ObservableObject {
    @Published private(set) var habits = [Habit]()
    private let habitRepository = HabitRepository.shared
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        
    }
    
    func loadHabits(){
        self.habitRepository
            .all()
            .print()
            .sink {
                self.habits = $0
            }.store(in: &subscriptions)
    }
    
    func deleteHabit(at offsets: IndexSet) {
        offsets
            .map { self.habits[$0] }
            .forEach {
                habitRepository.delete($0)
            }
        //TODO: load them again instead?
        // habits.remove(atOffsets: offsets)
        loadHabits()
    }
    
    func deleteHabit(_ habit: Habit) {
        habitRepository.delete(habit)
        loadHabits()
    }
}
