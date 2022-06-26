//
//  CoreDataStore.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

typealias CoreDataAction = (NSManagedObjectContext) -> Void

protocol CoreDataStore {
    /// NSManagedObjectContext property for CoreData
    var viewContext: NSManagedObjectContext { get }
    /// Generic method for entity creation
    func createEntity<T: NSManagedObject>() -> T
    /// Method for saving entities to CoreData database
    ///
    ///  utilizes Combine
    ///  - Parameter save: escaping closure that takes NSManagedOjbectContext as it's argument
    /// and performs save after closure is executed
    ///
    /// - Returns: ``CoreDataSavePublisher`` Publisher object 
    func publisher(save action: @escaping CoreDataAction) -> CoreDataSavePublisher
    /// Method for fetching entities from CoreData database
    ///
    /// utilizes Combine
    ///
    /// - Parameter fetch: NSFetchRequest that is executed within the returned publisher
    /// - Returns: ``CoreDataFetchPublisher`` Publisher object
    func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchPublisher<T>
    /// Method for deleting entities from CoreData database
    ///
    /// utilizes Combine
    ///
    /// - Parameter delete: Entity inheriting NSManagedObject class
    ///
    /// - Returns: ``CoreDataDeletePublisher`` Publisher object
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
    
    /// Creates NSPersistenContainer and performs loadPersistentStores
    ///
    /// - Parameter name: String name of the database
    init(name: String) {
        container = NSPersistentContainer(name: name)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading persistent stores \(error), \(error.localizedDescription)")
            }
        }
    }
}
