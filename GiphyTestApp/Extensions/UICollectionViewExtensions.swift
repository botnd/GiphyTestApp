//
//  UICollectionViewExtensions.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

extension UICollectionView {
    func dequeueReusableCell<T: CellInterface>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.id, for: indexPath) as? T else {
            fatalError("Cell is not of kind \(T.id)")
        }
        
        return cell
    }
    
    func register(cellInterface type: CellInterface.Type) {
        register(type.self, forCellWithReuseIdentifier: type.id)
    }
}
