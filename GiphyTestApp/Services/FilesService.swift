//
//  FilesService.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Combine
import Kingfisher

protocol FilesService {
    func saveImage(_ gif: Gif) -> AnyPublisher<Void, Never>
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
    func localURL(for id: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(id)
            .appendingPathExtension("gif")
    }
}
