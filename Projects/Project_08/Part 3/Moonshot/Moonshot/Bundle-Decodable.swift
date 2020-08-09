//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Eric Schofield on 8/5/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file :String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate '\(file)' in Bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file)")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode data from \(file)")
        }
        
        return loaded
    }
}
