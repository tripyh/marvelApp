//
//  Config+server.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import Foundation

struct Config {
    static let serverBaseURL: URL = {
        return URL(string: "https://gateway.marvel.com:443/")!
    }()
}
