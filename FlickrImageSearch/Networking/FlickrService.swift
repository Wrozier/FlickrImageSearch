//
//  FlickrService.swift
//  FlickrImageSearch
//
//  Created by William Rozier on 3/27/26.
//
import Foundation
import Combine

@MainActor
class FlickrService: ObservableObject {
    @Published var photos: [FlickrPhoto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne"
    
    // Removed debounce completely
    func search(tags: String) async {
        guard !tags.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
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
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("✅ HTTP Status: \(httpResponse.statusCode)")
            }
            
            let preview = String(data: data.prefix(800), encoding: .utf8) ?? "Invalid data"
            print("Response preview (first 800 chars):\n\(preview)\n...")
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let feed = try decoder.decode(FlickrFeed.self, from: data)
            
            self.photos = feed.items
            print("✅ SUCCESS: Loaded \(feed.items.count) photos for tags: \(tags)")
            
        } catch {
            print("❌ ERROR: \(error)")
            
            if let decodingError = error as? DecodingError {
                print("🔍 Detailed Decoding Error: \(decodingError)")
            }
            
            errorMessage = "Failed to load images. Please try different tags."
            photos = []
        }
    }
}
