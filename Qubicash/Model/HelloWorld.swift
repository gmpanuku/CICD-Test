//
//  User.swift
//  Qubicash
//
//  Created by Panuku Goutham on 07/04/22.
//

import Foundation

struct HelloWorld: Codable {
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case text
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? ""
    }
}
