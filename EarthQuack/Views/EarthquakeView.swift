//
//  ContentView.swift
//  EarthQuack
//
//  Created by dmu mac 25 on 15/05/2023.
//

import SwiftUI
import MapKit

struct EarthquakeView: View {
    @EnvironmentObject var rootValues: RootValues
    
    @EnvironmentObject var stateController: StateController
    
    @State private var selectedTab: StateController.EarthquakeSpan = .Day
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    NavigationLink {
                        EarthquakeUserView()
                    } label: {
                        Image(systemName: "star")
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    Button {
                        print("Earth Quack")
                        stateController.earthquakeFavourites = []
                        stateController.saveData()
                    } label: {
                        Text("🌎🦆 = \(stateController.earthquakes.count)")
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    Button {
                        print("TODO: Settings, Picker Magnitude Size, Detail images, Quack Alarm")
                        showAlert = true
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.gray)
                    }
                    .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Settings Feature"),
                                    message: Text("Coming Soon"),
                                    dismissButton: .default(Text("Ok"))
                                   
                                )
                            }
                }
                .font(.title)
                .padding(15)
                
                TabView(selection: $selectedTab){
                    ForEach(StateController.EarthquakeSpan.allCases, id: \.self) {
                        span in
                        EarthquakeListView()
                            .tabItem {
                                Image(systemName: "calendar.badge.clock")
                                Text(span.displayName)
                            }
                            .tag(span)
                    }
                }
                
            }
            .onChange(of: selectedTab) { newValue in
                stateController.fetchEarthquakes(from: URL(string: newValue.urlString)!)
            }
        }
    }
}

struct EarthquakeRoundedRectangularView: View {
    
    var earthquake: Earthquake
    
    @EnvironmentObject var stateController: StateController
    
    @EnvironmentObject var rootValues: RootValues
    
    var body: some View {
        HStack{
            // Magnitude Circle
            ZStack{
                Circle()
                    .frame(height: 50.0)
                    .foregroundColor(earthquake.properties.mag >= 5 ?     .red : earthquake.properties.mag <= 2.5 ? .green : .yellow)
                    .shadow(color: earthquake.properties.mag >= 5 ?     .red : earthquake.properties.mag <= 2.5 ? .green : .yellow, radius: 5)
                Text(String( format: "%.2f",
                             earthquake.properties.mag
                           ))
                .font(.title3)
                .fontWeight(    .bold)
                .foregroundColor(.white)
            }
            .padding(10)
            // Place and Time
            VStack(alignment: .leading){
                Text(earthquake.properties.place)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(earthquake.properties.formattedTime())
            }
            .foregroundColor(.black)
            Spacer()
            Button {
                if(stateController.earthquakeFavourites.contains { x in x.id == earthquake.id} == true) {
                    stateController.removeEarthquake(earthquake: earthquake)
                }
                else {
                    stateController.addEarthquake(earthquake: earthquake)
                }
            } label: {
                ZStack{
                    Circle()
                        .frame(height: 50.0)
                        .foregroundColor(stateController.earthquakeFavourites.contains { x in x.id == earthquake.id } ? .yellow : .white)
                    
                    Image(systemName: "star")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(stateController.earthquakeFavourites.contains { x in x.id == earthquake.id } ? .white : rootValues.colorLightGray)
                }
                .padding(10)
            }
        }
        .background(rootValues.colorLightGray)
        .cornerRadius(50)
        .shadow(color: earthquake.properties.mag >= 5 ? .red : Color(white: 0.0, opacity: 0) , radius: 3)
    }
}


struct EarthquakeListView: View {
    
    @EnvironmentObject var stateController: StateController
    
    var body: some View {
            ScrollView{
                LazyVStack{
                    ForEach(stateController.earthquakes) { eq in
                        NavigationLink {
                            EarthquakeMapDetailView(
                                earthquakeRegion:
                                    MKCoordinateRegion(
                                        center: CLLocationCoordinate2D(
                                            latitude: eq.geometry.coordinates[1],
                                            longitude: eq.geometry.coordinates[0]),
                                        span:
                                            MKCoordinateSpan(
                                                latitudeDelta: 10,
                                                longitudeDelta: 10)),
                                earthquake: eq)
                        } label: {
                            EarthquakeRoundedRectangularView(earthquake: eq)
                                .frame(height: 50)
                                .padding(10)
                            
                        }
                    }
                }
            }
        }
    }







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeView().environmentObject(StateController())
            .environmentObject(RootValues())
    }
}
