//
//  ContentView.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2020. 12. 11..
//

import SwiftUI

struct HabitView: View {
    var habit: Habit
    
    var body: some View {
        VStack() {
//            Image(systemName: habit.imageName)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 150, height: 150)
//                .clipped()
//                .shadow(radius: 3)
            Text(habit.name)
                .font(.title)
                .fontWeight(.medium)
            Form {
                Section {
                    HStack {
                        Text("Description")
                        Spacer()
                        Text(habit.description)
                            .foregroundColor(.gray)
                            .font(.callout)
                    }
                    HStack {
                        Text("Description")
                        Spacer()
                        Text(habit.description)
                            .foregroundColor(.gray)
                            .font(.callout)
                    }
                }
                Section {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Done for today")
                    })
                }
                Section {
                    Text("History comes here")
                }
            }
            
        }.listStyle(PlainListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView(habit: Habit(name: "Yoga"))
    }
}
