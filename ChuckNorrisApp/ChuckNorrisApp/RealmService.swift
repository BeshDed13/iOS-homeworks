//
//  RealmService.swift
//  ChuckNorrisApp
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @Persisted(primaryKey: true) var name: String
    @Persisted var quotes = List<Quote>()
}

class Quote: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var text: String
    @Persisted var createdAt: Date
    @Persisted(originProperty: "quotes") var category: LinkingObjects<Category>
}

class RealmService {
    
    let realm = try! Realm()
    
    func save(_ apiQuote: APIQuote) {
        try! realm.write {
            if realm.object(ofType: Quote.self, forPrimaryKey: apiQuote.id) != nil { return }
            let quote = Quote()
            quote.id = apiQuote.id
            quote.text = apiQuote.value
            quote.createdAt = Date()
            
            if let categoryName = apiQuote.categories.first, !categoryName.isEmpty {
                var category = realm.object(ofType: Category.self, forPrimaryKey: categoryName)
                if category == nil {
                    category = Category()
                    category!.name = categoryName
                    realm.add(category!)
                }
                category!.quotes.append(quote)
            }
            
            realm.add(quote)
        }
    }
    
    func fetchQuotes() -> Results<Quote> {
        return realm.objects(Quote.self).sorted(byKeyPath: "createdAt", ascending: true)
    }
    
    func fetchCategories() -> Results<Category> {
        return realm.objects(Category.self).sorted(byKeyPath: "name")
    }
}
