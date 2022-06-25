//
//  SearchVM.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

import Combine

class SearchVM {
    
    private let api: GiphyAPI

    private var gifsCancellable: AnyCancellable?
    private var searchCancellable: AnyCancellable?
    
    @Published
    private var cells: [SearchCellVM] = []
    var cellsPublisher: Published<[SearchCellVM]>.Publisher {
        $cells
    }
    
    private var offset: Int = 0
    
    @Published
    var searchQuery: String?
    
    init(api: GiphyAPI) {
        self.api = api
        
        loadData()
        
        searchCancellable = $searchQuery.sink { [weak self] query in
            self?.offset = 0
            self?.loadData(for: query)
        }
    }
    
    private func loadData(for query: String? = nil) {
        gifsCancellable?.cancel()
        
        let task: AnyPublisher<([Gif], Pagination), Never>
        if let query = query, !query.isEmpty {
            task = api.loadSearch(query, offset: offset, count: 48)
        } else {
            task = api.loadTrending(offset: offset, count: 48)
        }
        
        gifsCancellable = task.compactMap { [weak self] res in
            self?.offset += res.1.count
            
            return res.0
        }.sink { gifs in
            self.mapCells(gifs)
        }
            
    }
    
    private func mapCells(_ from: [Gif]) {
        cells = from.map { gif in
            SearchCellVM(gif: gif)
        }
    }
}
