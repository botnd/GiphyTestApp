//
//  ArrayExtensions.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

extension Array {
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
