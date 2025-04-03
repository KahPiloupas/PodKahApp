//
//  PodcastListViewModel.swift
//  PodKahApp
//
//  Created by Karina Piloupas on 28/03/25.
//

import Foundation

class PodcastListViewModel {
    
    private let podcastService = PodcastService()
    var podcasts: [Podcast] = []
    
    func fetchPodcasts(url: String, completion: @escaping (Result<[Podcast], Error>) -> Void) {
        podcastService.fetchPodcasts(from: url) { result, error   in
            if let result {
                completion(.success(result))
            } else {
                completion(.failure(PodcastError.noData))
            }
        }
    }
}

enum PodcastError: Error {
    case noData
}
