//
//  AtCoderProblemsRepository.swift
//  MoyaSample
//
//  Created by burita083 on 2020/08/27.
//  Copyright © 2020 burita083. All rights reserved.
//

import Foundation

struct AtCoderProblemsRepository: Codable {
    let id: String
    let contestId: String
    let title: String

    private enum CodingKeys: String, CodingKey {
        case id
        case contestId = "contest_id"
        case title
    }

}
