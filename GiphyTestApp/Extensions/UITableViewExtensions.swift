//
//  UITableViewExtensions.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 26.06.2022.
//

extension UITableView {
    func dequeueReusableCell<T: CellInterface>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.id, for: indexPath) as? T else {
            fatalError("Cell is not of kind \(T.id)")
        }
        
        return cell
    }
    
    func register(cellInterface type: CellInterface.Type) {
        register(type.self, forCellReuseIdentifier: type.id)
    }
}
