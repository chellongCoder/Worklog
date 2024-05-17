//
//  ContentView.swift
//  Worklog
//
//  Created by Mobile Programming  on 21/08/23.
//

import SwiftUI
import DeviceActivity
import FamilyControls
struct TotalActivityView: View {
    let totalActivity: String

    var body: some View {

        VStack {
            Text("Screen Time")

            Text(totalActivity)
        }
    }
}

// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
struct TotalActivityView_Previews: PreviewProvider {
    static var previews: some View {
        TotalActivityView(totalActivity: "1h 23m")
    }
}

struct ContentView: View {
    @State private var context: DeviceActivityReport.Context = .init(rawValue: "Total Activity")

    @State private var filter = DeviceActivityFilter(
        segment: .daily(
            during: Calendar.current.dateInterval(
               of: .day, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone, .iPad])
    )

  @State private var pickerIsPresented = false
  @ObservedObject var model: ScreenTimeSelectAppsModel
  @EnvironmentObject var modelScreenTime: ScreenTimeSelectAppsModel
  @Environment(\.presentationMode) var presentationMode


    
    
    var body: some View {
      VStack {
        DeviceActivityReport(context, filter: filter)
      Button {
                 pickerIsPresented = true
             } label: {
                 Text("Select Apps")
             }
             .familyActivityPicker(
                 isPresented: $pickerIsPresented,
                 selection: $model.activitySelection
             ).onChange(of: pickerIsPresented) { newValue in
                if !newValue {
                    // Picker has been dismissed
                  model.saveFamilyActivitySelection(selection: model.activitySelection)
                  model.startAppRestrictions()
                }
            }.padding(.bottom, 10) 

        Button {
          model.stopAppRestrictions()
               } label: {
                   Text("DeSelect Apps")
               }.padding(.bottom, 10)

      }
        ZStack {

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let model = ScreenTimeSelectAppsModel()

      ContentView(model: model)
    }
}
