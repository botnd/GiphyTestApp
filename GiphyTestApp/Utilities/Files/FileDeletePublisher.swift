//
//  FileDeletePublisher.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Combine

/// Implementation for Combine's Publisher protocol that performs file deleting
/// for the given URL
struct FileDeletePublisher: Publisher {
    typealias Output = Bool
    typealias Failure = Error
    
    let url: URL
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Bool == S.Input {
        let subscription = FileDeleteSubscription(subscriber: subscriber, url: url)
        
        subscriber.receive(subscription: subscription)
    }
}

extension FileDeletePublisher {
    fileprivate final class FileDeleteSubscription<S: Subscriber>: Subscription
    where S.Input == Bool, S.Failure == Error {
        private var subscriber: S?
        private let url: URL
        
        init(subscriber: S, url: URL) {
            self.subscriber = subscriber
            self.url = url
        }
        
        func request(_ demand: Subscribers.Demand) {
            var demand = demand
            guard let subscriber = subscriber, demand > 0 else {return}
            
            do {
                demand -= 1
                try FileManager.default.removeItem(at: url)
                demand += subscriber.receive(true)
                subscriber.receive(completion: .finished)
            } catch let error {
                subscriber.receive(completion: .failure(error))
            }
            
        }
        
        func cancel() {
            subscriber = nil
        }
    }
}
