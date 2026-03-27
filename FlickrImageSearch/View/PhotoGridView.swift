//
//  PhotoGridView.swift
//  FlickrImageSearch
//
//  Created by William Rozier on 3/27/26.
//

import SwiftUI

struct PhotoGridView: View {
    @StateObject private var service = FlickrService()
    @State private var searchText = ""
    
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 8)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                if service.isLoading {
                    ProgressView("Searching Flickr...")
                        .padding()
                } else if let error = service.errorMessage {
                    ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text(error))
                } else if service.photos.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView("No Results", systemImage: "photo.on.rectangle.angled", description: Text("Try different tags"))
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(service.photos) { photo in
                                NavigationLink(destination: PhotoDetailView(photo: photo)) {
                                    PhotoThumbnailView(photo: photo)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Flickr Search")
            .searchable(text: $searchText, prompt: "Search tags (e.g. porcupine, forest, bird)")
            .onChange(of: searchText) { _, newValue in
                Task {
                    await service.search(tags: newValue)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") {
                        searchText = ""
                    }
                    .disabled(searchText.isEmpty)
                }
            }
        }
    }
}
