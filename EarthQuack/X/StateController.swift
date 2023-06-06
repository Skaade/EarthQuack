//
//  StateController.swift
//  EarthQuack
//
//  Created by dmu mac 25 on 15/05/2023.
//

import Foundation
import MapKit

class StateController: ObservableObject {
    @Published var earthquakes: [Earthquake] = []
    
    @Published var earthquakeFavourites: [Earthquake] = []
    
    @Published var detail: EarthquakeDetail?
    
    @Published var mapRect = MKMapRect()
    
    enum EarthquakeSpan: String {
        case Hour
        case Day
        case Week
        case Month
        
        var displayName: String {
            switch self {
            case .Hour:
                return "Hour"
            case .Day:
                return "Day"
            case .Week:
                return "Week"
            case .Month:
                return "Month"
            }
        }
        
        var urlString: String {
            switch self {
            case .Hour:
                return "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson"
            case .Day:
                return "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"
            case .Week:
                return "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson"
            case .Month:
                return "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"
            }
        }
        
        static var allCases: [EarthquakeSpan] {
            return [.Hour, .Day, .Week, .Month]
        }
    }
    
    init() {
        loadData()
        fetchEarthquakes(from: URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")!)
    }
    
    
    func fetchEarthquakes(from url: URL) {
        Task(priority: .background) {
            guard let rawEarthquakesData = await NetworkService.getData(url) else { return }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            do {
                let decodedEarthquakeResult = try decoder.decode(EarthquakeResult.self, from: rawEarthquakesData)
                DispatchQueue.main.async {
                    self.earthquakes = decodedEarthquakeResult.results
                    self.earthquakes.sort {$0.properties.mag < $1.properties.mag}
                }
            } catch {
                print(error)
                fatalError("Error while converting rawData to EarthquakeResult instance")
            }
        }
    }
    
    func fetchEarthquakeDetail(from url: URL) {
        Task(priority: .background) {
            guard let rawEarthquakeDetailData = await NetworkService.getData(url) else { return }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            do {
                let decodedEarthquakeDetailResult = try decoder.decode(EarthquakeDetail.self, from: rawEarthquakeDetailData)
                DispatchQueue.main.async {
                    self.detail = decodedEarthquakeDetailResult
                }
            } catch {
                print(error)
                fatalError("Error while converting rawData to EarthquakeDetail instance")
            }
        }
    }
    
    
    func addEarthquake(earthquake: Earthquake) {
        if (!earthquakeFavourites.contains(where: { eq in
            eq.id == earthquake.id})) {
            earthquakeFavourites.append(earthquake)
            saveData()
        }
    }
    
    func removeEarthquake(earthquake: Earthquake) {
        if(earthquakeFavourites.count > 0){
            let index: Int = earthquakeFavourites.firstIndex {eq in eq.id == earthquake.id} ?? -1
            if(index != -1){
                earthquakeFavourites.remove(at: index)
                saveData()
            }
        }
    }

    func saveData() {
        guard let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let filePath = fileURL.appendingPathComponent("earthquakeFavourites.json")

        do {
            let data = try JSONEncoder().encode(earthquakeFavourites)
            try data.write(to: filePath)
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }

    func loadData() {
        guard let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let filePath = fileURL.appendingPathComponent("earthquakeFavourites.json")

        do {
            let data = try Data(contentsOf: filePath)
            earthquakeFavourites = try JSONDecoder().decode([Earthquake].self, from: data)
        } catch {
            print("Failed to load data: \(error.localizedDescription)")
        }
    }
    
}
