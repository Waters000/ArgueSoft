//
//  Config.swift
//  ArgueSoft
//
//  Created by Chris waters on 12/11/22.
//

import UIKit

struct Config: Decodable {
    // add keys here
//    let title: String
//    let done: Bool
    let Tip1: Tip1
    let Tip2: Tip2
    let Tip3: Tip3
    
}

struct Tip1: Decodable {
    let title: String
    let done: Bool
}
struct Tip2: Decodable {
    let title: String
    let done: Bool
}
struct Tip3: Decodable {
    let title: String
    let done: Bool
}

struct ConfigValues {
    static func get() -> Config {
        guard let url = Bundle.main.url(forResource: "preloadedData", withExtension: "plist") else {
            fatalError("Couldn not find preloadedData.plist in your bundle")
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            return try decoder.decode(Config.self, from: data)
        } catch let err {
            fatalError(err.localizedDescription)
        }
    }
}
