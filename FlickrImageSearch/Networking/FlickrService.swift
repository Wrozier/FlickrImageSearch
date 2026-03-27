//
//  FlickrService.swift
//  FlickrImageSearch
//
//  Created by William Rozier on 3/27/26.
//

import Foundation

@MainActor
class FlickrService: ObservableObject {
    @Published var photos: [FlickrPhoto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne"
    
    func search(tags: String) async {
        guard !tags.trimmingCharacters(in: .whitespaces).isEmpty else {
            photos = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "tags", value: tags)
        ]
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = queryItems
        
        guard let url = components.url else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // The feed sometimes has minor quirks, but with nojsoncallback=1 it should be clean
            let decoder = JSONDecoder()
            let feed = try decoder.decode(FlickrFeed.self, from: data)
            
            self.photos = feed.items
        } catch {
            self.errorMessage = "Failed to load images: \(error.localizedDescription)"
            print("Decoding error: \(error)")
        }
        
        isLoading = false
    }
}
