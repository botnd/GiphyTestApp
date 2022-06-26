//
//  CoreDataFetchPublisher.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Combine

struct CoreDataFetchPublisher<Entity>: Publisher where Entity: NSManagedObject {
    typealias Output = [Entity]
    typealias Failure = Error
    
    private let request: NSFetchRequest<Entity>
    private let context: NSManagedObjectContext
    
    init(request: NSFetchRequest<Entity>, context: NSManagedObjectContext) {
        self.request = request
        if self.request.sortDescriptors == nil {
            self.request.sortDescriptors = []
        }
        self.context = context
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, [Entity] == S.Input {
        let subscription = CoreDataFetchSubscription(subscriber: subscriber, context: context, request: request)
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataFetchPublisher {
    fileprivate final class CoreDataFetchSubscription<S>: NSObject, Subscription, NSFetchedResultsControllerDelegate where S: Subscriber, Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private var request: NSFetchRequest<Entity>
        private var context: NSManagedObjectContext
        private var controller: NSFetchedResultsController<Entity>?
        
        init(subscriber: S, context: NSManagedObjectContext, request: NSFetchRequest<Entity>) {
            self.subscriber = subscriber
            self.context = context
            self.request = request
        }
        
        func request(_ demand: Subscribers.Demand) {
            var demand = demand
            guard let subscriber = subscriber, demand > 0 else {
                return
            }
            
            controller = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
            controller?.delegate = self

            do {
                demand -= 1
                try controller?.performFetch()
                if let items = controller?.fetchedObjects {
                    demand += subscriber.receive(items)
                }
            } catch {
                subscriber.receive(completion: .failure(error))
            }
        }
        
        func cancel() {
            subscriber = nil
            controller = nil
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            guard let subscriber = subscriber, let controller = self.controller else {
                return
            }

            if let items = controller.fetchedObjects {
                _ = subscriber.receive(items)
            }
        }
    }
}
