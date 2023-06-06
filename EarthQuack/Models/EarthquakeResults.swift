//
//  EarthquakeResults.swift
//  EarthQuack
//
//  Created by dmu mac 25 on 15/05/2023.
//

import Foundation

struct EarthquakeResult: Codable {
    let results: [Earthquake]
    
    enum CodingKeys: String, CodingKey {
          case results = "features"
    }
}
