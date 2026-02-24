//
//  FavoritesService.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import CoreData

final class FavoritesService {
    
    private let context = CoreDataStack.shared.context
    
    func save(post: Post) {
        
        if isPostSaved(author: post.author, description: post.description) { return }
        
        let favorite = FavoritePost(context: context)
        favorite.author = post.author
        favorite.postDescription = post.description
        favorite.image = post.image
        favorite.likes = Int64(post.likes)
        favorite.views = Int64(post.views)
        try? context.save()
    }
    
    func fetchPosts() -> [FavoritePost] {
        let request: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func isPostSaved(author: String, description: String) -> Bool {
        let request: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        request.predicate = NSPredicate(format: "author == %@ AND postDescription == %@", author, description)
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }
}
