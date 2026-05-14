//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 14.05.2026.
//

import Foundation

final class FeedViewModel {

    private let catService = CatService()

    private(set) var posts: [Post] = []

    var onPostsUpdated: (() -> Void)?

    func fetchCats() {

        Task {

            do {

                let cats = try await catService.fetchCats()

                let loadedPosts = cats.enumerated().map { index, cat in

                    Post(
                        author: "Киска #\(index + 1)",
                        description: "Кошка из API!",
                        image: cat.url,
                        likes: Int.random(in: 1...999),
                        views: Int.random(in: 100...10000)
                    )
                }

                await MainActor.run {

                    self.posts = loadedPosts
                    self.onPostsUpdated?()
                }

            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func likePost(at index: Int) {

        posts[index].likes += 1
    }
}
