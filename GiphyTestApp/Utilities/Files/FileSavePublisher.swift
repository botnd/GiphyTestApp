//
//  FileSavePublisher.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Combine
import Kingfisher

struct FileSavePublisher: Publisher {
    typealias Output = Void
    typealias Failure = Error
    
    let from: URL
    let to: URL
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Void == S.Input {
        let subscription = FileSaveSubscription(subscriber: subscriber, from: from, to: to)
        
        subscriber.receive(subscription: subscription)
    }
}

extension FileSavePublisher {
    fileprivate final class FileSaveSubscription<S: Subscriber>: Subscription
        where S.Input == Void, S.Failure == Error {
        private var subscriber: S?
        private let from: URL
        private let to: URL
        
        init(subscriber: S, from: URL, to: URL) {
            self.subscriber = subscriber
            self.from = from
            self.to = to
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard demand > 0 else {return}
            
            KingfisherManager.shared.downloader.downloadImage(with: from) { [weak self] res in
                guard let self = self else {return}
                switch res {
                case .success(let image):
                    do {
                        try image.originalData.write(to: self.to)
                        _ = self.subscriber?.receive()
                        self.subscriber?.receive(completion: .finished)
                    } catch let error {
                        self.subscriber?.receive(completion: .failure(error))
                    }
                case .failure(let error):
                    self.subscriber?.receive(completion: .failure(error))
                }
            }
            
        }
        
        func cancel() {
            subscriber = nil
        }
    }
}
