//
//  GiphyAPI.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Foundation
import Combine

protocol GiphyAPI {
    func loadTrending(offset: Int, count: Int) -> AnyPublisher<([Gif], Pagination), Never>
    func loadSearch(_ query: String, offset: Int, count: Int) -> AnyPublisher<([Gif], Pagination), Never>
}

class GiphyApiDefaultImpl: GiphyAPI {
    private let apiURL = "https://api.giphy.com/v1/"
    private let apiKey = "saMS6GVBpSc9h5rAF6e7hqkRryFaCTYi"
        
    private func buildURL(from baseURL: String? = nil, path: String, qs: [String: String]? = nil) -> URL? {
        var urlComponents = URLComponents(string: baseURL ?? apiURL)
        urlComponents?.path += path
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        if let qs = qs {
            urlComponents?.queryItems?
                .append(contentsOf: qs.map {
                    URLQueryItem(name: $0.key, value: $0.value)
                })
        }
        
        return urlComponents?.url
    }
    
    private func fetchGifs(for url: URL) -> AnyPublisher<([Gif], Pagination), Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GiphyResponse.self, decoder: JSONDecoder())
            .compactMap { response in
                (response.data, response.pagination)
            }
            .replaceError(with: ([Gif](), Pagination(offset: 0, totalCount: 0, count: 0)))
            .eraseToAnyPublisher()
    }
    
    func loadTrending(offset: Int, count: Int = 50) -> AnyPublisher<([Gif], Pagination), Never> {
        let url = buildURL(path: "gifs/trending", qs: [
            "offset": String(offset),
            "limit": String(count)
        ])!
        
        return fetchGifs(for: url)
    }
    
    func loadSearch(_ query: String, offset: Int, count: Int = 50) -> AnyPublisher<([Gif], Pagination), Never> {
        let url = buildURL(path: "gifs/search", qs: [
            "q": query,
            "offset": String(offset),
            "limit": String(count)
        ])!
        
        return fetchGifs(for: url)
    }
}
