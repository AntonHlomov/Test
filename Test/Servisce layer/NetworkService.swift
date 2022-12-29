//
//  NetworkService.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//

import Foundation
import UIKit

var imagePostCache = [String: ImgaePost]()//Cache

protocol NetworckServiceProtocol {
    func getImage(link: String,completion: @escaping (Result<ImgaePost?,Error>) -> Void)
}
class NetworkService:NetworckServiceProtocol {
    func getImage(link: String,completion: @escaping (Result<ImgaePost?, Error>) -> Void) {
        // check if there is a photo in the cache
        if let cachedImage = imagePostCache[link] {
            completion(.success(cachedImage))
            return }
        let url = URL(string: link)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            guard let imageData = UIImage(data: data) else {return }
            let imagePost = ImgaePost.init(photo: imageData, link: link)
            imagePostCache[url.absoluteString] = imagePost
            completion(.success(imagePost))
        }
        task.resume()
    }
}
