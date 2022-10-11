//
//  ContentView.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2020. 12. 11..
//

import SwiftUI
import Introspect
import Combine


struct HabitsView: View {
    
    // TODO:
    // - @ObservedObject vs @StateObject
    // - https://stackoverflow.com/questions/62544115/what-is-the-difference-between-observedobject-and-stateobject-in-swiftui
    @ObservedObject private var habitsViewModel = HabitsViewModel()
    @State private var showDetails: Bool = false
    
    
    
    
    
    
    func delete(at offsets: IndexSet) {
        habitsViewModel.deleteHabit(at: offsets)
    }
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(habitsViewModel.habits, id: \.id) {habit in
                    HabitRow(habit: habit)
                        .swipeActions(edge: .leading) {
                            NavigationLink(destination: HabitDetailsView(habit: habit), isActive: $showDetails) {
                                Button(action: {
                                    showDetails = true
                                }) {
                                    Text("Reszletek")
                                }
                            }
                            
                            Button {
                                print("view details btn")
                            } label: {
                                Label("Details", systemImage: "heart")
                                        .font(.title)
                                        .labelStyle(.titleOnly)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            deleteButton(habit: habit)
                        }
                }
                .onDelete(perform: self.delete)
                    
                    
            }
            .navigationBarTitle("Habits")
            .navigationBarItems(trailing: NewButton() )
            .introspectTableView { tableView in
//                tableView.separatorStyle = .none
//                tableView.
//                tableView.separatorStyle = .none
//                tableView.backgroundColor = .green      
            }.onAppear {
                self.habitsViewModel.loadHabits()
            }
        }
        
    }
    
    
    func deleteButton(habit: Habit) -> some View {
        Button(role: .destructive) {
            habitsViewModel.deleteHabit(habit)
            print("delete")
        } label: {
            Label("Delete", systemImage: "trash")
                .labelStyle(.iconOnly)
        }
    }
}



struct NewButton: View {
    @State private var showNewHabitView: Int? = nil
    
    var body: some View {
        NavigationLink(destination: NewHabitView(), tag: 1, selection: $showNewHabitView) {
            Button(action: {
                showNewHabitView = 1
            }){
                Text("New")
            }
        }
    }
}


struct HabitRow: View {
    @ObservedObject var model: HabitRowViewModel
    @State private var showHabitDetails = false
    
    init(habit: Habit) {
        model = HabitRowViewModel(habit: habit)
    }
    
    // NOTE: Two buttons in a row bug in SwiftUI: https://stackoverflow.com/questions/56576298/swiftui-two-buttons-in-a-list
    var body: some View {
        HStack {
            switchDoneButton
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.system(size: 21, weight: .medium, design: .default))
                Text(model.habit.description)
                WeeklyProgressView(weeklyProgress: $model.weeklyProgress)
            }
            Spacer()
            infoButton
            Spacer()
        }
        
    }
    
    
    
    var switchDoneButton: some View {
        Button(action: {
            model.nextStatus()// TODO: too many .
            // model.toggleToday()
            print("Next color: \(model.habit.dailyStatus().color)")
        }) {
            Image(systemName: model.habit.isTodayDone() ? "checkmark.circle.fill" : "circle")
            //Image(systemName: "circle")
                .resizable()
                .foregroundColor(model.color()) // TODO: too many .
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .clipped()
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    
    var infoButton: some View {
        Group {
            Image(systemName: "info.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .clipped()
                .onTapGesture {
                    print("infobutton")
                    showHabitDetails = true
                }
            NavigationLink(destination: HabitDetailsView(habit: self.model.habit), isActive: $showHabitDetails ) {EmptyView()}
            .hidden().frame(width: 0)


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
    
    func dayColor(_ dailyProgress: DailyStatus) -> Color {
        switch dailyProgress {
            case .unknown: return .gray
            case .showedUp: return .yellow
            case .done: return .green
            case .missed: return .red

        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsView()
    }
}

