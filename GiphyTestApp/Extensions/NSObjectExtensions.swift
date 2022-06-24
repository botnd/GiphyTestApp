//
//  NSObjectExtensions.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

import Foundation

extension NSObject {
    public var nameOfClass: String {
        NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? ""
    }
}
