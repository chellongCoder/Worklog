//
//  WorklogApp.swift
//  Worklog
//
//  Created by Mobile Programming  on 21/08/23.
//

import SwiftUI
import FamilyControls
import DeviceActivity


@main
struct Worklog: App {
    let center = AuthorizationCenter.shared


    
    var body: some Scene {
        WindowGroup {
          let model = ScreenTimeSelectAppsModel()

          ContentView(model: model)
            
            .onAppear {
                Task {
                    do {
                        try await center.requestAuthorization(for: .individual)
                      let now = Date()
                      let oneHourLater = Calendar.current.date(byAdding: .hour, value: 1, to: now)!

                      let nowComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
                      let oneHourLaterComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: oneHourLater)
                      model.startMonitoring(scheduleStart: nowComponents, scheduleEnd: nowComponents)                    } catch {
                        print("Failed to enroll Aniyah with error: \(error)")
                    }
                }
            }
        }
    }
}
