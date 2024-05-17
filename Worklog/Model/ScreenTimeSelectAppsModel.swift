//
//  ScreenTimeSelectAppsModel.swift
//  Worklog
//
//  Created by Longnn on 04/05/2024.
//

import Foundation
import ManagedSettings
import FamilyControls
import DeviceActivity
class ScreenTimeSelectAppsModel: ObservableObject {
    @Published var activitySelection = FamilyActivitySelection()
     @Published var selectionToEncourage: FamilyActivitySelection
    static let shared = ScreenTimeSelectAppsModel()

    let store = ManagedSettingsStore(named: .mySettingStore)
    private let userDefaultsKey = "ScreenTimeSelection"
    // Used to encode codable to UserDefaults
    private let encoder = PropertyListEncoder()

    // Used to decode codable from UserDefaults
    private let decoder = PropertyListDecoder()
    // The Device Activity schedule represents the time bounds in which my extension will monitor for activity
    let schedule = DeviceActivitySchedule(
        // I've set my schedule to start and end at midnight
        intervalStart: DateComponents(hour: 0, minute: 0),
        intervalEnd: DateComponents(hour: 11, minute: 17),
        // I've also set the schedule to repeat
        repeats: true
    )
  @Published var selectionToDiscourage = FamilyActivitySelection() {
      willSet {
        let applications = newValue.applicationTokens
        let categories = newValue.categoryTokens
        let webCategories = newValue.webDomainTokens
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
        store.shield.webDomains = webCategories
       }
    }

    init() {
      selectionToDiscourage = FamilyActivitySelection()
      selectionToEncourage = FamilyActivitySelection()

    }

  //save family activity selection to UserDefault
   func saveFamilyActivitySelection(selection: FamilyActivitySelection) {
       print("selected app updated: ", selection.applicationTokens.count," category: ", selection.categoryTokens.count)
       let defaults = UserDefaults.standard

       defaults.set(
           try? encoder.encode(selection),
           forKey: userDefaultsKey
       )

       //check is data saved to user defaults
       getSavedFamilyActivitySelection()
   }

  //get saved family activity selection from UserDefault
     func getSavedFamilyActivitySelection() -> FamilyActivitySelection? {
         let defaults = UserDefaults.standard
         guard let data = defaults.data(forKey: userDefaultsKey) else {
             return nil
         }
         var selectedApp: FamilyActivitySelection?
         let decoder = PropertyListDecoder()
         selectedApp = try? decoder.decode(FamilyActivitySelection.self, from: data)

         print("saved selected app updated: ", selectedApp?.categoryTokens.count ?? "0")
         return selectedApp
     }

  func startMonitoring(scheduleStart: DateComponents, scheduleEnd: DateComponents) {

    let schedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0),
                                          intervalEnd: DateComponents(hour: 11, minute: 17), repeats: true, warningTime: nil)
      print(scheduleStart)
      print(scheduleEnd)
      let center = DeviceActivityCenter()
      do {
        try center.startMonitoring(.activity, during: schedule)
      }
      catch {
        print ("Could not start monitoring \(error)")
      }

      store.dateAndTime.requireAutomaticDateAndTime = false
      store.account.lockAccounts = false
      store.passcode.lockPasscode = false
      store.siri.denySiri = false
      store.appStore.denyInAppPurchases = false
      store.appStore.maximumRating = 1000
      store.appStore.requirePasswordForPurchases = false
      store.media.denyExplicitContent = false
      store.gameCenter.denyMultiplayerGaming = false
      store.media.denyMusicService = false
      store.application.denyAppInstallation = false
  }

  func startAppRestrictions() {
          print("Start App Restriction")

          // Pull the selection out of the app's model and configure the application shield restriction accordingly
  //        let applications = MyModel.shared.familyActivitySelection
          let applications = getSavedFamilyActivitySelection()

          if(applications == nil){
              print("application not selected")
              return
          }


          if applications!.applicationTokens.isEmpty {
              print("empty applicationTokens")
          }

          if applications!.categoryTokens.isEmpty {
              print("empty categoryTokens")
          }

          //lock application
          store.shield.applications = applications!.applicationTokens.isEmpty ? nil : applications!.applicationTokens
          store.shield.applicationCategories = applications!.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(applications!.categoryTokens)

          //more rules
          store.media.denyExplicitContent = true

          //prevent app removal
          store.application.denyAppRemoval = true

          //prevent set date time
          store.dateAndTime.requireAutomaticDateAndTime = true
          store.application.blockedApplications = applications!.applications

      }

    // count selected category
     func countSelectedAppCategory() -> Int {
 //        let applications = MyModel.shared.familyActivitySelection
         let applications = getSavedFamilyActivitySelection()

         if(applications == nil){
             print("application not selected")
             return 0
         }
         return applications!.categoryTokens.count
     }

     // count selected category
     func countSelectedApp() -> Int {
         let applications = getSavedFamilyActivitySelection()
         if(applications == nil){
             print("category not selected")
             return 0
         }
         return applications!.applicationTokens.count
     }

      func stopAppRestrictions(){
         print("Stop App Restriction")
         store.clearAllSettings()
     }

}
extension DeviceActivityName {
    static let restrictAppActivityName = Self("restrictApp")
    static let activity = Self("activity")
    static let daily = Self("daily") 
}

// I want to remove the application shield restriction when the child accumulates enough usage for a set of guardian-selected encouraged apps
extension DeviceActivityEvent.Name {
    // Set the name of the event to "encouraged"
    static let encouraged = Self("encouraged")
}



extension ManagedSettingsStore.Name {
    static let mySettingStore = Self("mySettingStore")
}


