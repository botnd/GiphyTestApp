//
//  CoreDataSavePublisher.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Combine

/// Implementation for Combine's Publisher protocol that performs saving to CoreData database
/// performs given closure within provided NSManagedObjectContext and calls save() method on the context
struct CoreDataSavePublisher: Publisher {
    typealias Output = Bool
    typealias Failure = Error
    
    private let action: CoreDataAction
    private let context: NSManagedObjectContext
    
    init(action: @escaping CoreDataAction, context: NSManagedObjectContext) {
        self.action = action
        self.context = context
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Bool == S.Input {
        let subscription = CoreDataSaveSubscription(subscriber: subscriber, context: context, action: action)
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataSavePublisher {
    fileprivate final class CoreDataSaveSubscription<S>: Subscription where S: Subscriber, Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private let action: CoreDataAction
        private let context: NSManagedObjectContext
        
        init(subscriber: S, context: NSManagedObjectContext, action: @escaping CoreDataAction) {
            self.subscriber = subscriber
            self.context = context
            self.action = action
        }
        
        func request(_ demand: Subscribers.Demand) {
            var demand = demand
            guard let subscriber = subscriber, demand > 0 else {return}
            
            do {
                action(context)
                demand -= 1
                try context.save()
                demand += subscriber.receive(true)
            } catch {
                subscriber.receive(completion: .failure(error))
            }
        }
        
        func cancel() {
            subscriber = nil
        }
    }
    
}
