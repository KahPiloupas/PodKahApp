//
//  PodcastDetailViewModel.swift
//  PodKahApp
//
//  Created by Karina Piloupas on 28/03/25.
//

import Foundation

class PodcastDetailViewModel {
    
    private var podcast: Podcast
    
    init(podcast: Podcast) {
        self.podcast = podcast
    }
    
    func getPodcastDetails() -> Podcast {
        return podcast
    }
}
