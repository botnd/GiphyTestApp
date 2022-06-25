//
//  Image.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Foundation

struct Image {
    let url: URL?
    let width: Float?
    let height: Float?
}

extension Image: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        width = try Float(container.decodeIfPresent(String.self, forKey: .width) ?? "0")
        height = try Float(container.decodeIfPresent(String.self, forKey: .height) ?? "0")
    }
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case width = "width"
        case height = "height"
    }
}
