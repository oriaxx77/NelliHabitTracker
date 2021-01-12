//
//  ContentView.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2020. 12. 11..
//

import SwiftUI
import Introspect




struct HabitsView: View {
    
    @ObservedObject var habitRepository: HabitRepository = .shared
    
    func delete(at offsets: IndexSet) {
        habitRepository.habits.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView {
            List {
                
                ForEach(habitRepository.habits, content: HabitRow.init(habit:))
                    .onDelete(perform: self.delete)
                
//                ForEach(habitRepository.habits, id: \.id) { habit in
//                    //NavigationLink(destination: HabitView(habit: habit)) {
//                        HabitRow(habit: habit)
//                    //}
//                }.onDelete(perform: self.delete)
                
            }
            .navigationBarTitle("Habits")
            .navigationBarItems(trailing: NewButton() )
            .introspectTableView { tableView in
//                tableView.separatorStyle = .none
//                tableView.
//                tableView.separatorStyle = .none
//                tableView.backgroundColor = .green      
            }
        }
        
    }
}

struct NewButton: View {
    @State private var showNewHabitView: Int? = nil
    
    var body: some View {
//        Button(action: {
//            self.showNewHabitView.toggle()
//        }) {
//            Text("New")
//        }.sheet(isPresented: $showNewHabitView) {
//            NewHabitView()
//       }
        NavigationLink(destination: NewHabitView(), tag: 1, selection: $showNewHabitView) {
            Button(action: {
                showNewHabitView = 1
            }){
                Text("New")
            }
        }
    }
    
    
}

struct WeeklyProgressView: View {
    
    @Binding var weeklyProgress: WeeklyProgress
    
    var body: some View {
        HStack {
            ForEach(weeklyProgress.progress, id: \.id) { dailyProgress in
                Text(dailyProgress.day.initial()).foregroundColor(dayColor(dailyProgress.progress))
            }
        }
    }
    
    func dayColor(_ dailyProgress: DailyProgress) -> Color {
        switch dailyProgress {
        case .unknown: return .gray
        case .done: return .green
        case .missed: return .red}
    }
}

struct HabitRow: View {
    @ObservedObject var habit: Habit
    
    var body: some View {
        HStack {
            switchDoneButton
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.system(size: 21, weight: .medium, design: .default))
                Text(habit.description)
                WeeklyProgressView(weeklyProgress: $habit.progress.weeklyProgress)
            }
            Spacer()
            
        }
    }
    
    var switchDoneButton: some View {
        Button(action: {
            habit.done.toggle()
                }) {
        Image(systemName: habit.done ? "checkmark.circle.fill" : "circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60)
            .clipped()
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsView()
    }
}

