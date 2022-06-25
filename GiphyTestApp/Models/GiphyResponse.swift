//
//  GiphyResponse.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

struct Pagination {
    let offset: Int
    let totalCount: Int
    let count: Int
}

extension Pagination: Decodable {
    enum CodingKeys: String, CodingKey {
        case offset = "offset"
        case totalCount = "total_count"
        case count = "count"
    }
}

struct GiphyResponse {
    let data: [Gif]
    let pagination: Pagination
}

extension GiphyResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case pagination = "pagination"
    }
}
