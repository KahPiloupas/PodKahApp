//
//  Podcast.swift
//  PodKahApp
//
//  Created by Karina Piloupas on 28/03/25.
//

import Foundation

struct Podcast {
    var title: String
    var description: String
    var imageURL: String
    var author: String
    var genre: String
    var episodes: [Episode]
}

struct Episode {
    var title: String
    var description: String
    var genre: String
    var audioURL: String
    var duration: String
    var imageURL: String
}

