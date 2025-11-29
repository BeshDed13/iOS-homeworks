//
//  Post.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 29.11.2025.
//

import Foundation

struct Post {
    let author: String
    let description: String
    let image: String
    let likes: Int
    let views: Int
}

let posts: [Post] = [
    Post(author: "user1", description: "description1", image: "image1", likes: 10, views: 100),
    Post(author: "user2", description: "description2", image: "image2", likes: 20, views: 1000),
    Post(author: "user3", description: "description3", image: "image3", likes: 50, views: 500),
    Post(author: "user4", description: "description4", image: "image4", likes: 100, views: 100),
]
