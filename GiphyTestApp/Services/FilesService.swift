//
//  FilesService.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Combine
import Kingfisher

protocol FilesService {
    /// Method that saves gif image to local documents directory
    ///
    /// - Parameter gif: ``Gif`` object that needs to be saved
    ///
    /// - Returns: Combine publisher for this operation
    func saveImage(_ gif: Gif) -> AnyPublisher<Void, Never>
    /// Method that removes previously saved gif image from local documents directory
    ///
    /// - Parameter id: String ``Gif/id`` identifier field
    ///
    /// - Returns: Combine publisher for this operation
    func removeImage(id: String) -> AnyPublisher<Bool, Never>
}

class FilesServiceDefaultImpl: FilesService {
    func saveImage(_ gif: Gif) -> AnyPublisher<Void, Never> {
        guard let url = gif.original?.url else {
            return Just(()).eraseToAnyPublisher()
        }
        
        return FileSavePublisher(from: url, to: localURL(for: gif.id))
            .replaceError(with: ())
            .eraseToAnyPublisher()
    }
    
    func removeImage(id: String) -> AnyPublisher<Bool, Never> {
        return FileDeletePublisher(url: localURL(for: id))
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
}

fileprivate extension FilesServiceDefaultImpl {
    /// Method used for building local URL for file
    ///
    /// builds URL for documentDirectory within UserDomain
    ///
    /// appends id as filename and ".gif" as extension
    ///
    /// - Parameter for: String ``Gif/id`` field
    ///
    /// - Returns: URL Object for given id
    func localURL(for id: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(id)
            .appendingPathExtension("gif")
    }
}
