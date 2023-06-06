//
//  EarthQuackApp.swift
//  EarthQuack
//
//  Created by dmu mac 25 on 15/05/2023.
//

import SwiftUI

@main
struct EarthQuackApp: App {
    
    @StateObject var stateController = StateController()
    @StateObject var rootValues = RootValues()
    
    var body: some Scene {
        WindowGroup {
            EarthquakeView()
                .environmentObject(stateController)
                .environmentObject(rootValues)
        }
    }
}
