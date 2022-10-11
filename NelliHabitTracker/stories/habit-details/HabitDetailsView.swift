//
//  HabitDetailsView.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2021. 07. 16..
//

import SwiftUI

struct HabitDetailsView: View {
    @State var habit: Habit
    
    var body: some View {
        Text("Habit details view \(habit.name)")
    }
}

//struct HabitDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitDetailsView()
//    }
//}
