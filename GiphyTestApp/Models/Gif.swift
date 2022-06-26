//
//  Gif.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Foundation

struct Gif {
    let id: String
    let url: URL
    let title: String
    let downsized: Image?
    let original: Image?
    var saved: SavedGif?
}

extension Gif: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        url = try container.decode(URL.self, forKey: .url)
        title = try container.decode(String.self, forKey: .title)
        
        let images = try container.decode([String: Image].self, forKey: .images)
        downsized = images["downsized"]
        original = images["original"]
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case url = "url"
        case title = "title"
        case images = "images"
    }
}
