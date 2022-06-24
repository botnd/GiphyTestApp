//
//  CellInterface.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

protocol CellInterface: AnyObject {
    static var id: String { get }
    static var cellNib: UINib { get }
}

extension CellInterface {
    static var id: String {
        return String(describing: Self.self)
    }
    
    static var cellNib: UINib {
        return UINib(nibName: id, bundle: nil)
    }
}
