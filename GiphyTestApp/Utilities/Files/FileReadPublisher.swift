//
//  FileSavePublisher.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Combine

struct FileReadPublisher: Publisher {
    typealias Output = Data
    typealias Failure = Error
    
    let fileUrl: URL
    
    func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, Data == S.Input {
        let subscription = FileSaveSubscription(subscriber: subscriber, fileUrl: fileUrl)
        
        subscriber.receive(subscription: subscription)
    }
}

extension FileReadPublisher {
    fileprivate final class FileSaveSubscription<S: Subscriber>: Subscription
        where S.Input == Data, S.Failure == Error {
        private var subscriber: S?
        private let fileUrl: URL
        
        init(subscriber: S, fileUrl: URL) {
            self.subscriber = subscriber
            self.fileUrl = fileUrl
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard demand > 0 else {return}
            
            do {
                let data = try Data(contentsOf: fileUrl)
                _ = subscriber?.receive(data)
                subscriber?.receive(completion: .finished)
            } catch let error {
                subscriber?.receive(completion: .failure(error))
            }
        }
        
        func cancel() {
            subscriber = nil
        }
    }
}
