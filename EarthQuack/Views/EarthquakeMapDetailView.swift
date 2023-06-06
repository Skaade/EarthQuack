//
//  EarthquakeDetailView.swift
//  EarthQuack
//
//  Created by dmu mac 25 on 16/05/2023.
//

import SwiftUI
import MapKit

struct EarthquakeMapDetailView: View {
    
    @EnvironmentObject var stateController: StateController
    
    @EnvironmentObject var rootValues: RootValues
    
    @State var earthquakeRegion: MKCoordinateRegion
    
    @State var earthquake: Earthquake
    
    @State private var isCoverPresented = false
    
    var body: some View {
        VStack{
            Map(
                coordinateRegion: $earthquakeRegion,
                annotationItems: stateController.earthquakes){ eq in
                    MapAnnotation(
                        coordinate: CLLocationCoordinate2D(
                            latitude: eq.geometry.coordinates[1],
                            longitude: eq.geometry.coordinates[0]),
                        anchorPoint: CGPoint(x: 0.5, y: 0.5))
                    {
                        ZStack{
                            Circle()
                                .frame(height: 50.0)
                                .foregroundColor(eq.properties.mag >= 5 ?     .red : eq.properties.mag <= 2.5 ? .green : .yellow)
                                .shadow(color: eq.properties.mag >= 5 ?     .red : .black, radius: 5)
                            Text(String( format: "%.2f",
                                         eq.properties.mag
                                       ))
                            .font(.title3)
                            .fontWeight(    .bold)
                            .foregroundColor(.white)
                        }
                        
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: eq.id == earthquake.id ? 3 : 1)
                        )
                        .onTapGesture {
                            earthquake = eq
                            earthquakeRegion.center = CLLocationCoordinate2D(
                                latitude: eq.geometry.coordinates[1],
                                longitude: eq.geometry.coordinates[0]
                            )
                        }
                        
                    }
                    
                    
                    
                }
            
                .frame(width: 350.0, height: 350.0)
                .clipShape(Circle())
                .shadow(radius: 5)
            Spacer()
            VStack{
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
                Text(earthquake.properties.place)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(earthquake.properties.formattedTime())
            }
            Spacer()
            ZStack{
                
                Button {
                     stateController.fetchEarthquakeDetail(from: URL(string: earthquake.properties.detail)!)
                    isCoverPresented.toggle()
                } label: {
                        Text("Show Earthquake Detail")
                    
                    .foregroundColor(.white)
                    
                }
                .buttonStyle(.borderedProminent)
                .background()
                .cornerRadius(50)
                HStack{
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
                                .frame(width: 35, height: 35)
                            
                                .foregroundColor(stateController.earthquakeFavourites.contains { x in x.id == earthquake.id } ? .yellow : rootValues.colorLightGray)
                            Image(systemName: "star")
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.trailing, 25.0)
                    
                    
                    
                }
                
            }
            
            
            Text("ID: \(earthquake.id)")
                .padding(15)
        }
        .fullScreenCover(isPresented: $isCoverPresented) {
            EarthquakeDetailView()
                .onTapGesture {
                    isCoverPresented.toggle()
                }
            
        }
        
    }
    
}



struct EarthquakeMapDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let testCoordinateRegion = MKCoordinateRegion()
        
        let testEarthquake = Earthquake(
            properties: Earthquake.Properties(
                mag: 7.2,
                place: "San Francisco",
                time: Date.now,
                updated: Date.now,
                url: "https://example.com/earthquake",
                detail: "A major earthquake occurred in San Francisco."),
            geometry: Earthquake.Geometry(
                coordinates: [37.7749, -122.4194]),
            id: "1234567890")
        EarthquakeMapDetailView(earthquakeRegion: testCoordinateRegion, earthquake: testEarthquake)
            .environmentObject(StateController())
            .environmentObject(RootValues())
    }
}
