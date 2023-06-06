//
//  EarthquakeUserView.swift
//  EarthQuack
//
//  Created by dmu mac 25 on 16/05/2023.
//

import SwiftUI
import MapKit

struct EarthquakeUserView: View {
    
    
    
    @EnvironmentObject var stateController: StateController
    
    var body: some View {
        if stateController.earthquakeFavourites.count != 0 {
            
                ScrollView{
                    ForEach(stateController.earthquakeFavourites) { eq in
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
            
            .navigationTitle(Text(" Favourites: \(stateController.earthquakeFavourites.count)"))
        }
        
        else {
        
            Text("No favourites")
                .foregroundColor(.gray)
                .navigationTitle(Text(" Favourites"))
        }
        
    }
}

struct EarthquakeUserView_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeUserView()
            .environmentObject(StateController())
    }
}
