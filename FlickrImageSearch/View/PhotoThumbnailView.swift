//
//  PhotoThumbnailView.swift
//  FlickrImageSearch
//
//  Created by William Rozier on 3/27/26.
//

import SwiftUI

struct PhotoThumbnailView: View {
    let photo: FlickrPhoto
    
    var body: some View {
        AsyncImage(url: URL(string: photo.media.m)) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(ProgressView())
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            case .failure:
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(Image(systemName: "photo").foregroundColor(.gray))
            @unknown default:
                EmptyView()
            }
        }
        .frame(height: 180)
        .clipped()
        .shadow(radius: 2)
    }
}
