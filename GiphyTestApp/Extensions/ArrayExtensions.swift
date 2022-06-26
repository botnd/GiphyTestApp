//
//  ArrayExtensions.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

extension Array {
    /// Performs a safe check of index and returns Optional of the Element
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
