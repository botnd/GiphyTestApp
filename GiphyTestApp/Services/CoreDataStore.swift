//
//  CoreDataStore.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

typealias CoreDataAction = (NSManagedObjectContext) -> Void

protocol CoreDataStore {
    var viewContext: NSManagedObjectContext { get }
    func createEntity<T: NSManagedObject>() -> T
    func publisher(save action: @escaping CoreDataAction) -> CoreDataSavePublisher
    func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchPublisher<T>
    func publisher<T: NSManagedObject>(delete entity: T) -> CoreDataDeletePublisher<T>
}

extension CoreDataStore {
    func createEntity<T: NSManagedObject>() -> T {
        T(context: viewContext)
    }
    
    func publisher(save action: @escaping CoreDataAction) -> CoreDataSavePublisher {
        CoreDataSavePublisher(action: action, context: viewContext)
    }
    
    func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchPublisher<T> {
        CoreDataFetchPublisher(request: request, context: viewContext)
    }
    
    func publisher<T: NSManagedObject>(delete entity: T) -> CoreDataDeletePublisher<T> {
        CoreDataDeletePublisher(delete: entity, context: viewContext)
    }
}

class CoreDataStoreDefaultImpl: CoreDataStore {
    private let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    static var `default`: CoreDataStore = {
        return CoreDataStoreDefaultImpl(name: "GiphyTestApp")
    }()
    
    init(name: String) {
        container = NSPersistentContainer(name: name)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading persistent stores \(error), \(error.localizedDescription)")
            }
        }
    }
}
