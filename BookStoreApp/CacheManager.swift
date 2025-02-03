//
//  CacheManager.swift
//  BookStoreApp
//
//  Created by Mine Rala on 3.02.2025.
//

import UIKit

final class CacheManager {
    static let shared = CacheManager()
    private let imageCache = NSCache<NSString, UIImage>()

    private init() {}

    // Önbellekten resim al
    func getImage(for url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString)
    }

    // Resmi önbelleğe kaydet
    func cacheImage(_ image: UIImage, for url: String) {
        imageCache.setObject(image, forKey: url as NSString)
    }

    // Resmi yükle, önbellekten kontrol et ve indirme işlemini yap
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        // Önbellekten kontrol et
        if let cachedImage = getImage(for: url) {
            completion(cachedImage)
            return
        }

        // URL geçerli mi kontrol et
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }

        // Resmi indir
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(nil)
                return
            }

            // Önbelleğe kaydet
            self.cacheImage(image, for: url)

            // UI güncellemesi ana thread üzerinde yapılmalı
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
