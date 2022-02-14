//
//  ComicsResponse.swift
//  MarvelApp
//
//  Created by andrey rulev on 14.02.2022.
//

import Foundation

struct ComicsResponse {
    let data: ComicsData
    
    init(data: ComicsData) {
        self.data = data
    }
}

// MARK: - Decodable

extension ComicsResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(ComicsData.self, forKey: .data)
        self.init(data: data)
    }
}
