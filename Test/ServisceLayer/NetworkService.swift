//
//  NetworkService.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//

import Foundation
import UIKit

protocol NetworckServiceProtocol {
    func loadImage(completion: @escaping (UIImage?) -> Void)
}

class NetworkService:NetworckServiceProtocol {
  
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            let url = URL(string: "https://picsum.photos/900")!
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            completion(image)
            
        }
    }
}



