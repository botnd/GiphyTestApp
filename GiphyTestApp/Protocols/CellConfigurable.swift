//
//  CellConfigurable.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

protocol CellConfigurable {
    associatedtype VMType
    
    func configure(with vm: VMType)
}
