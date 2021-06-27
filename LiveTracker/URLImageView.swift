//
//  URLImageView.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 27/06/2021.
//

import SwiftUI

struct URLImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    
    init(url: URL) {
        urlImageModel = UrlImageModel(url: url)
    }
    
    var body: some View {
        Image(uiImage: urlImageModel.image ?? URLImageView.defaultImage!)
            .resizable()
            .scaledToFit()
    }
    
    static var defaultImage = UIImage(named: "jersey")
}

class UrlImageModel: ObservableObject {
    var imageCache = ImageCache.getImageCache()

    @Published var image: UIImage?
    var url: URL
    
    init(url: URL) {
        self.url = url
        loadImage()
    }
    
    func loadImage() {
        if loadImageFromCache() {
            return
        }
        loadImageFromUrl()
    }
    
    func loadImageFromCache() -> Bool {
        
        guard let cacheImage = imageCache.get(forKey: url.absoluteString) else {
            return false
        }
        
        image = cacheImage
        return true
    }
    
    func loadImageFromUrl() {
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            self.imageCache.set(forKey: self.url.absoluteString, image: loadedImage)
            self.image = loadedImage
        }
    }
}
