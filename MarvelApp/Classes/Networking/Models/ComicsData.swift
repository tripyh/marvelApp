//
//  ComicsData.swift
//  MarvelApp
//
//  Created by andrey rulev on 14.02.2022.
//

import Foundation

struct ComicsData {
    let results: [Comics]
    
    init(results: [Comics]) {
        self.results = results
    }
}

// MARK: - Decodable

extension ComicsData: Decodable {
    private enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.decode([Comics].self, forKey: .results)
        self.init(results: results)
    }
}
