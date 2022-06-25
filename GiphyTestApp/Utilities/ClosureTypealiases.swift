//
//  ClosureTypealiases.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

typealias Action = () -> Void

typealias BoolAction = (Bool) -> Void

typealias StringAction = (String?) -> Void

typealias Failure = (Error?) -> Void

typealias GifAction = (Gif) -> Void
