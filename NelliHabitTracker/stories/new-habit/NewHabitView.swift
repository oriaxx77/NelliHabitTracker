//
//  NewHabitView.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2020. 12. 11..
//

import SwiftUI
import Combine
import Bow




struct NewHabitView: View {
  
    @ObservedObject private var newHabitViewModel: NewHabitViewModel
    @Environment(\.presentationMode) var presentationMode
    
  
    init() {
        self.newHabitViewModel = NewHabitViewModel(habitRepository: .shared)
    }
      
    
    var body: some View {
        
            Form {
                
                if case .saved = newHabitViewModel.state {
                    Section {
                        Text("Your habit saved!")
                                .fontWeight(.light)
                                .foregroundColor(Color.green)
                    }
                }
                
                
                Section {
                        TextField("Habit name", text: $newHabitViewModel.habitName)
                            .autocapitalization(.none)
                           // .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                        if(!newHabitViewModel.habitNameMessage.isEmpty) {
                            Text(newHabitViewModel.habitNameMessage)
                                .fontWeight(.light)
                                .font(.footnote)
                                .foregroundColor(Color.red)
                        }
                        
                        TextField("Habit description", text: $newHabitViewModel.habitDescription)
                            .autocapitalization(.none)
                        
                        if(!newHabitViewModel.habitDescriptionMessage.isEmpty) {
                            Text(newHabitViewModel.habitDescriptionMessage)
                                .fontWeight(.light)
                                .font(.footnote)
                                .foregroundColor(Color.red)
                        }
                }
                Section {
                    Button(action: { newHabitViewModel.save() }) {
                        Text("Save")
                            .foregroundColor(newHabitViewModel.isValidHabit ? .blue : .gray)
                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .background(Color.red)
                    }
                    .disabled(!self.newHabitViewModel.isValidHabit)
//                    .padding([.leading, .trailing], 20)
                }.navigationBarTitle(Text("New Habit"), displayMode: .large)
            }
        }
    
}


/*
  struct ValidationModifier: ViewModifier {
      @State var latestValidation: Validation = .success
      let validationPublisher: ValidationPublisher
      func body(content: Content) -> some View {
          return VStack(alignment: .leading) {
              content
              validationMessage
          }.onReceive(validationPublisher) { validation in
              self.latestValidation = validation
          }
      }
      var validationMessage: some View {
          switch latestValidation {
          case .success:
              return AnyView(EmptyView())
          case .failure(let message):
              let text = Text(message)
                  .foregroundColor(Color.red)
                  .font(.caption)
              return AnyView(text)
          }
      }
  }
  */

struct NewHabitView_Previews: PreviewProvider {
    static var previews: some View {
        NewHabitView()
    }
}


