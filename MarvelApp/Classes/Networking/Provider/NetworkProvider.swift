//
//  NetworkProvider.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import Moya

protocol NetworkTarget: TargetType {
    
}

extension NetworkTarget {
    var baseURL: URL {
        return Config.serverBaseURL
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return [:]
    }
}
