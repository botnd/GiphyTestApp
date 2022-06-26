//
//  CellConfigurable.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

/// A type that can be configured with associated viewModel type
protocol CellConfigurable {
    associatedtype VMType
    
    /// Configure cell with it's viewModel
    ///
    /// Good place to set data passed from viewModel, such as texts, images and bindings
    ///
    /// - Parameter vm: viewModel of associated type ``VMType``
    func configure(with vm: VMType)
}
