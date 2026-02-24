//
//  FavoritesService.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import CoreData

final class FavoritesService {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func save(post: Post) throws {
        do {
            if try isPostSaved(author: post.author, description: post.description) { return }
            
            let favorite = FavoritePost(context: context)
            favorite.author = post.author
            favorite.postDescription = post.description
            favorite.image = post.image
            favorite.likes = Int64(post.likes)
            favorite.views = Int64(post.views)
            
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchPosts() throws -> [Post] {
        do {
            let request: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
            let results = try context.fetch(request)
            return results.map {
                Post(author: $0.author ?? "", description: $0.postDescription ?? "", image: $0.image ?? "", likes: Int($0.likes), views: Int($0.views))
            }
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func isPostSaved(author: String, description: String) throws -> Bool {
        do {
            let request: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
            request.predicate = NSPredicate(format: "author == %@ AND postDescription == %@", author, description)
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
