//
//  PodcastService.swift
//  PodKahApp
//
//  Created by Karina Piloupas on 28/03/25.
//

import Foundation

class PodcastService: NSObject, XMLParserDelegate {
    
    private var podcasts: [Podcast] = []
    private var currentPodcast: Podcast?
    private var currentEpisode: Episode?
    
    private var currentElement = ""
    private var currentText = ""
    private var currentAudioURL: String?
    private var currentImageURL: String?
    private var isInItem = false
    
    func fetchPodcasts(from url: String, completion: @escaping ([Podcast]?, Error?) -> Void) {
        guard let feedURL = URL(string: url) else {
            completion(nil, NSError(domain: "PodcastService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        let task = URLSession.shared.dataTask(with: feedURL) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "PodcastService", code: 400, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
                return
            }
            
            self.podcasts = []
            self.currentPodcast = nil
            self.currentEpisode = nil
            self.currentElement = ""
            self.currentText = ""
            self.currentAudioURL = nil
            self.currentImageURL = nil
            self.isInItem = false
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            
            if parser.parse() {
                completion(self.podcasts, nil)
            } else {
                completion(nil, NSError(domain: "PodcastService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse XML"]))
            }
        }
        task.resume()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        podcasts = []
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Parsing completed")
        
        if let podcast = currentPodcast, !podcasts.contains(where: { $0.title == podcast.title }) {
            podcasts.append(podcast)
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        currentText = ""
        print("==> (attributes): \(attributeDict)")
        let element = qName ?? elementName
        let namespace = namespaceURI ?? ""
        
        switch element {
        case "channel":
            if currentPodcast == nil {
                currentPodcast = Podcast(title: "", description: "", imageURL: "", author: "", genre: "", episodes: [])
            }
        case "item":
            isInItem = true
            currentEpisode = Episode(title: "", description: "",genre: "", audioURL: "", duration: "", imageURL: currentPodcast?.imageURL ?? "")
        case "enclousure":
            if isInItem, let audioURL = attributeDict["url"] {
                currentEpisode?.audioURL = audioURL
            }
        case "itunes:image", "image":
            if let url = attributeDict["href"] ?? attributeDict["url"] {
                if isInItem {
                    currentEpisode?.imageURL = url
                } else {
                    currentPodcast?.imageURL = url
                }
            }
        case "itunes:duration":
            currentElement = "duration"
        case "itunes:author":
            currentElement = "author"
        case "itunes:summary":
            currentElement = "summary"
        case "itunes:category":
            if let category = attributeDict["text"] {
                if isInItem {
                    currentEpisode?.genre = category
                } else {
                    currentPodcast?.genre = category
                }
            }
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let trimmedText = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        if isInItem {
            switch elementName {
            case "title":
                currentEpisode?.title = trimmedText
            case "description", "itunes:summary", "summary":
                let cleanDescription = trimmedText
                    .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "<!\\[CDATA\\[|\\]\\]>", with: " ", options: .regularExpression)
                currentEpisode?.description = cleanDescription
            case "itunes:duration", "duration":
                currentEpisode?.duration = trimmedText
            case "pubDate", "pubdate":
                break
            case "item":
                isInItem = false
                if let episode = currentEpisode {
                    if let audioURL = currentAudioURL {
                        currentEpisode?.audioURL = audioURL
                    }
                    currentPodcast?.episodes.append(episode)
                }
                currentEpisode = nil
                currentAudioURL = nil
            default:
                break
            }
        } else {
            switch elementName {
            case "title":
                currentPodcast?.title = trimmedText
            case "description", "itunes:summary", "summary":
                let cleanDescription = trimmedText
                    .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "<!\\[CDATA\\[|\\]\\]>", with: "", options: .regularExpression)
                currentPodcast?.description = cleanDescription
            case "itunes:author", "author":
                currentPodcast?.author = trimmedText
            case "channel":
                if let podcast = currentPodcast, !podcast.title.isEmpty {
                    podcasts.append(podcast)
                }
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentText += string
    }
}
