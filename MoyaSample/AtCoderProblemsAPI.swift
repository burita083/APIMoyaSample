//
//  MoyaAtCoder.swift
//  MoyaSample
//
//  Created by burita083 on 2020/08/27.
//  Copyright © 2020 burita083. All rights reserved.
//

import Foundation
import Moya

enum AtCoderProblemsAPI {
    case problems
}

extension AtCoderProblemsAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://kenkoooo.com/atcoder/resources")!
    }
    
    var path: String {
        switch self {
        case .problems:
            return "/problems.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .problems:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .problems:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
