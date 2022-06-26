//
//  UICollectionViewExtensions.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

extension UICollectionView {
    /// Generic method to dequeue cell of ``CellInterface`` type
    ///
    /// - Warning: will call fatalError if type cannot be dequeued
    func dequeueReusableCell<T: CellInterface>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.id, for: indexPath) as? T else {
            fatalError("Cell is not of kind \(T.id)")
        }
        
        return cell
    }
    
    /// Generic method for registering cell of ``CellInterface`` type
    func register(cellInterface type: CellInterface.Type) {
        register(type.self, forCellWithReuseIdentifier: type.id)
    }
}
