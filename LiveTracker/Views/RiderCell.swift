//
//  RiderCell.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 27/06/2021.
//

import SwiftUI

struct RiderCell: View {
    
    @ObservedObject private var viewModel: RiderCellViewModel

    init(rank: RankedRider) {
        self.viewModel = RiderCellViewModel(rank: rank)
    }
    
    var body: some View {
        HStack {
            Text(viewModel.position)
                .font(.footnote)
            if let image = viewModel.jerseyImage {
                Image(uiImage: image)
                    .frame(width: 20, height: 20)
                    .padding()
            } else {
                Image(systemName: "icloud.and.arrow.down")
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
            }
            Text(viewModel.bib)
                .font(.footnote)
                .frame(width: 25, alignment: .trailing)
            Text(viewModel.name)
            
            Spacer()
            
            Button {
                viewModel.toggleStar()
            } label: {
                Image(systemName: viewModel.isStarred ? "star.fill" : "star")
                    .foregroundColor(viewModel.isStarred ? .yellow : .gray)
            }
        }
    }
}

private final class RiderCellViewModel: ObservableObject {

    var position: String {
        "\(rank.position.Pos)"
    }
    
    var bib: String {
        "\(rank.rider.bib!)"
    }
    
    var name: String {
        rank.rider.name
    }
    
    @Published var isStarred: Bool = false
    @Published var jerseyImage: UIImage?
    
    private let rank: RankedRider
    private var imageCache = ImageCache.shared

    init(rank: RankedRider) {
        self.rank = rank
        isStarred =  StarredBibs.shared.savedBibs.contains(rank.rider.bib!)
        loadImage()
    }
    
    func toggleStar() {
        if isStarred {
            StarredBibs.shared.remove(bib: rank.rider.bib!)
        } else {
            StarredBibs.shared.add(bib: rank.rider.bib!)
        }
        isStarred =  StarredBibs.shared.savedBibs.contains(rank.rider.bib!)
    }
    
    private func loadImage() {
        if loadImageFromCache() {
            return
        }
        loadImageFromUrl()
    }
    
    private func loadImageFromCache() -> Bool {
        
        guard let url = rank.rider.team?.jerseyURL, let cacheImage = imageCache.get(forKey: url.absoluteString) else {
            return false
        }
        
        jerseyImage = cacheImage
        return true
    }
    
    func loadImageFromUrl() {
        guard let url = rank.rider.team?.jerseyURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil, let data = data, let loadedImage = UIImage(data: data) else {
            return
        }
        imageCache.set(forKey: rank.rider.team!.jerseyURL.absoluteString, image: loadedImage)

        DispatchQueue.main.async {
            self.jerseyImage = loadedImage
        }
    }
}
