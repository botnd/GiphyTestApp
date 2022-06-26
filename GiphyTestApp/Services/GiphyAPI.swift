//
//  GiphyAPI.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Foundation
import Combine

protocol GiphyAPI {
    /**
     Loads gifs from Trending tab at Giphy
     
    - Parameter offset: integer indicating how many items we should skip
    - Parameter count: integer indicating how many items we want to retrieve
     
    - Returns: a Combine Publisher passing an array of ``Gif`` objects and a ``Pagination`` object
     */
    func loadTrending(offset: Int, count: Int) -> AnyPublisher<([Gif], Pagination), Never>
    
    /**
     Loads gifs based on search query
     
     - Parameter query: String parameter on which the search is performed
     - Parameter offset: integer indicating how many items we should skip
     - Parameter count: integer indicating how many items we want to retrieve
     
     - Returns: a Combine Publisher passing an array of ``Gif`` objects and a ``Pagination`` object
     */
    func loadSearch(_ query: String, offset: Int, count: Int) -> AnyPublisher<([Gif], Pagination), Never>
}

class GiphyApiDefaultImpl: GiphyAPI {
    private let apiURL = "https://api.giphy.com/v1/"
    private let apiKey = "saMS6GVBpSc9h5rAF6e7hqkRryFaCTYi"
    
    /**
     Private method that builds a url for ``URLSession``
     
     resulting url is build from private ``apiURL`` property and ``apiKey`` property is passed to query string
     
     - Parameter from: baseURL optional String that can override private ``apiURL`` property, default is nil
     - Parameter path: String parameter that is responsible for which method of GiphyAPI is going to be invoked
     - Parameter qs: Optional dictionary of string keys and values, additional query string parameters can be passed through this
     
     - Returns: URL optional built from the given parameters
     */
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
    
    /**
     Private base method used to perform requests to GiphyAPI
     
     - Parameter for: url - URL parameter that is passed to ``URLSession`` to create a dataTaskPublisher
     
     Uses ``JSONDecoder`` for decoding
     
     On error returns empty array and a ``Pagination`` with zero values
     
     - Returns: AnyPublisher containig a tuple with the resulting array of ``Gif`` objects and the ``Pagination`` object
     */
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
