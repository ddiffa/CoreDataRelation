//
//  PersistanceManager.swift
//  RelationCoreData
//
//  Created by Diffa Desyawan on 16/06/21.
//

import Foundation
import CoreData


class PersistanceManager {
    static let shared = PersistanceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "RelationCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func setAuthor(name: String, hobby: String) {
        let author = Author(context: persistentContainer.viewContext)
        author.id = UUID()
        author.name = name
        author.hobby = hobby
        save()
    }
    
    func setBook(title: String, desc: String, imageData: Data, author: Author) {
        let book = Book(context: persistentContainer.viewContext)
        book.id = UUID()
        book.title = title
        book.desc = desc
        book.image = imageData
        book.author = author
        save()
    }
    
    func fetchAuthors() -> [Author] {
        let request: NSFetchRequest<Author> = Author.fetchRequest()
        
        var authors: [Author] = []
        
        do {
            authors = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetching authors")
        }
        
        return authors
    }
    
    func deleteAuthor(author : Author) {
        persistentContainer.viewContext.delete(author)
        save()
    }
    
    func deleteBook(book: Book) {
        persistentContainer.viewContext.delete(book)
        save()
    }
    
    func fetchBook(author: Author) -> [Book] {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        
        request.predicate = NSPredicate(format: "(author = %@)", author)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        var books: [Book] = []
        
        do{
            books = try persistentContainer.viewContext.fetch(request)
        }catch {
            print("Error fetching books data")
        }
        return books
    }
    
    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
