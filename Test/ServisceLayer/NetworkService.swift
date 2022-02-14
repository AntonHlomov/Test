//
//  NetworkService.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//

import Foundation
import UIKit

protocol NetworckServiceProtocol {
    func loadImage(link: String,completion: @escaping (ImgaePost?) -> Void)
   
}

class NetworkService:NetworckServiceProtocol {
  
    func loadImage(link: String,completion: @escaping (ImgaePost?) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            let url = URL(string: link)!
            guard let data = try? Data(contentsOf: url) else { return }
            guard let imageData = UIImage(data: data) else { return }
            let image = ImgaePost.init(photo: imageData, link: link)
            completion(image)
            
        }
    }
}



