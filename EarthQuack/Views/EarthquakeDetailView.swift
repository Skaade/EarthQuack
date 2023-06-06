//
//  EarthquakeDetailView.swift
//  EarthQuack
//
//  Created by dmu mac 25 on 17/05/2023.
//

import SwiftUI

struct EarthquakeDetailView: View {
    
    @EnvironmentObject var stateController: StateController
    
    @EnvironmentObject var rootValues: RootValues
    
    var body: some View {
        ZStack{
            Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1)
            if stateController.detail == nil {
                ProgressView()
            }
            else {
                VStack{
                    Spacer()
                    HStack{
                        
                        VStack(alignment: .leading, spacing: 5){
                            Text("ID: ")
                            Text("Place: ")
                            Text("Time: ")
                            Text("Updated: ")
                            Text("Magnitude: ")
                            Text("Latitude: ")
                            Text("Longitude: ")
                        }
                        .fontWeight(.bold)
                        VStack(alignment: .leading, spacing: 5){
                            Text("\(stateController.detail!.id)")
                            Text("\(stateController.detail!.properties.place)")
                            
                            Text("\(stateController.detail!.properties.formattedTime())")
                            Text("\(stateController.detail!.properties.formattedUpdated())")
                            Text("\(stateController.detail!.properties.mag)")
                            Text("\(stateController.detail!.geometry.coordinates[1])")
                            Text("\(stateController.detail!.geometry.coordinates[0])")
                        }
                    }
                    
                    
                    Spacer(minLength: 300)
                    Text("Source: \(stateController.detail!.properties.url)")
                        .padding([.leading, .bottom, .trailing], 10)
                }
                
            }
        }
        .ignoresSafeArea()
    }
}

struct EarthquakeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeDetailView()
            .environmentObject(StateController())
            .environmentObject(RootValues())
    }
}
