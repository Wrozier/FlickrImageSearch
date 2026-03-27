//
//  PhotoDetailView.swift
//  FlickrImageSearch
//
//  Created by William Rozier on 3/27/26.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: FlickrPhoto
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: photo.media.highResURL ?? URL(string: photo.media.m)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    default:
                        ProgressView()
                            .frame(height: 300)
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(photo.title.isEmpty ? "Untitled" : photo.title)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text("By \(photo.author.replacingOccurrences(of: "nobody@flickr.com", with: "Anonymous"))")
                        .foregroundColor(.secondary)
                    
                    if let published = photo.published {
                        Text("Published: \(formatDate(published))")
                            .font(.subheadline)
                    }
                    
                    if !photo.tagList.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Tags")
                                .font(.headline)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(photo.tagList, id: \.self) { tag in
                                        Text(tag)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.blue.opacity(0.1))
                                            .foregroundColor(.blue)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }
                    
                    if let desc = photo.description, !desc.isEmpty {
                        Text("Description")
                            .font(.headline)
                        Text(desc)
                            .font(.body)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Photo Details")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: URL(string: photo.link) ?? URL(string: photo.media.m)!) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    private func formatDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: isoString) else { return isoString }
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
}
