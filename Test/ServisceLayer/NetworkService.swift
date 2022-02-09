//
//  NetworkService.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//

import Foundation

protocol NetworckServiceProtocol {
    func getImages(compleation:@escaping(Result<[ImgaePost]?, Error>) -> Void)
}

class NetworkService:NetworckServiceProtocol {
    func getImages(compleation: @escaping (Result<[ImgaePost]?, Error>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/photos"
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                compleation(.failure(error))
                return
            }
            
            do {
                let obj = try JSONDecoder().decode([ImgaePost].self, from: data!)
                compleation(.success(obj))
            } catch {
                compleation(.failure(error))
            }
        }.resume()  // если запрос подвис запрос повториться
    }
}



