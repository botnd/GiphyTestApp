//
//  CoreDataDeletePublisher.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Combine

/// Implementation for Combine's Publisher protocol that performs fetching from CoreData database
/// calls delete on provided NSManagedObjectContext and passes given entity to it
struct CoreDataDeletePublisher<Entity: NSManagedObject>: Publisher {
    typealias Output = Bool
    typealias Failure = Error
    
    private let entity: Entity
    private let context: NSManagedObjectContext
    
    init(delete entity: Entity, context: NSManagedObjectContext) {
        self.entity = entity
        self.context = context
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Bool == S.Input {
        let subscription = CoreDataDeleteSubscription(subscriber: subscriber, entity: entity, context: context)
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataDeletePublisher {
    fileprivate final class CoreDataDeleteSubscription<S>: Subscription where S: Subscriber, Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private let entity: Entity
        private var context: NSManagedObjectContext
        
        init(subscriber: S, entity: Entity, context: NSManagedObjectContext) {
            self.subscriber = subscriber
            self.entity = entity
            self.context = context
        }
        
        func request(_ demand: Subscribers.Demand) {
            var demand = demand
            guard let subscriber = subscriber, demand > 0 else {
                return
            }
            do {
                demand -= 1
                context.delete(entity)
                try context.save()
                demand += subscriber.receive(true)
                subscriber.receive(completion: .finished)
            } catch {
                subscriber.receive(completion: .failure(error))
            }
        }
        
        func cancel() {
            subscriber = nil
        }
    }
}
