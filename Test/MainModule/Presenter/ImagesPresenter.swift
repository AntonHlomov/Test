//
//  ImagesPresenter.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//

import Foundation
import UIKit

//outPut
protocol ImagesViewProtocol: AnyObject {
    func succes(image: UIImage)
}
//inPut
protocol ImagesViewPresenterProtocol: AnyObject {
    init(view: ImagesViewProtocol, networkService: NetworckServiceProtocol)
    func loadImage() // запрашиваем фото из сети
    var cache: NSCache<NSNumber, UIImage> { get set } //сохраняем полученное фото в кеш
    //var imageP: UIImage? {get set}
}

class ImagesPresenter: ImagesViewPresenterProtocol {
    
    
    weak var view: ImagesViewProtocol?
    let networkService: NetworckServiceProtocol!
    var cache = NSCache<NSNumber, UIImage>()
    //var imageP: UIImage?
    
    required init (view: ImagesViewProtocol, networkService: NetworckServiceProtocol) {
        
        self.view = view
        self.networkService = networkService

       // loadImage() // потом переместить там где нужно его запустить
    }
    
   
    func loadImage() {
        networkService.loadImage{ [weak self] (image) in
            guard let self = self, let image = image else { return }
            DispatchQueue.main.async { [self] in
                self.view?.succes(image:image)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
