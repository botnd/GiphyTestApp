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
    
    @Published
    private var cells: [SearchCellVM] = []
    var cellsPublisher: Published<[SearchCellVM]>.Publisher {
        $cells
    }
    
    private var offset: Int = 0
    
    init(api: GiphyAPI) {
        self.api = api
        
        loadData()
    }
    
    private func loadData() {
        gifsCancellable?.cancel()
        
        let task = api.loadTrending(offset: offset, count: 48)
        
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
