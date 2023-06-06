//
//  Earthquake.swift
//  EarthQuack
//
//  Created by dmu mac 25 on 15/05/2023.
//

import Foundation

struct Earthquake: Codable, Identifiable {
    var properties: Properties
    let geometry: Geometry
    let id: String
    
    struct Geometry: Codable {
        let coordinates: [Double]
    }

    struct Properties: Codable {
        let mag: Double
        let place: String
        let time: Date
        let updated: Date
        let url: String
        let detail: String
    }
    
}

extension Earthquake.Properties {
    func formattedTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. MMM - yyyy - HH:mm:ss"
        return dateFormatter.string(from: time)
    }
    
    func formattedUpdated() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. MMM - yyyy - HH:mm:ss"
        return dateFormatter.string(from: updated)
    }
}


