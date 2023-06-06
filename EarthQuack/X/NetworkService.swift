//
//  NetworkService.swift
//  EarthQuack
//
//  Created by dmu mac 25 on 15/05/2023.
//

import Foundation

class NetworkService {
    
    static func getData(_ url: URL) async -> Data? {
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        let (data, response) = try! await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { return nil}
        if httpResponse.statusCode != 200 {
            fatalError("Error")
        }
        return data
    }
}
