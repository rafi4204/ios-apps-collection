//
//  PodcastRssParser.swift
//  podcast
//
//  Created by rafi on 13/7/26.
//

import Foundation

class PodcastRSSParser: NSObject, XMLParserDelegate {
    private var episodes: [Episode] = []
    
    private var currentElement = ""
    private var currentTitle = ""
    private var currentPubDate = ""
    private var currentAudioURL = ""
    private var currentDuration = ""
    
    func parse(xmlData: Data) -> [Episode] {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()
        return episodes
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "item" {
            currentTitle = ""
            currentPubDate = ""
            currentAudioURL = ""
            currentDuration = ""
        }
        
        if elementName == "enclosure", let url = attributeDict["url"] {
            currentAudioURL = url
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        switch currentElement {
        case "title": currentTitle += trimmed
        case "pubDate": currentPubDate += trimmed
        case "itunes:duration": currentDuration += trimmed
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let episode = Episode(
                title: currentTitle,
                pubDate: currentPubDate,
                audioURL: currentAudioURL,
                duration: currentDuration.isEmpty ? nil : currentDuration
            )
            if !episode.audioURL.isEmpty {
                episodes.append(episode)
            }
        }
    }
}
