//
//  SavedGif.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

class SavedGif: NSManagedObject {
    var pathURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(gifId ?? "")
            .appendingPathExtension("gif")
    }
}
