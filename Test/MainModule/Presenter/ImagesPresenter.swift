//
//  ImagesPresenter.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//

import Foundation
import UIKit

protocol ImagesViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
    
}

protocol ImagesViewPresenterProtocol: AnyObject {
    init(view: ImagesViewProtocol, networkService: NetworckServiceProtocol)
    func getImages() // запрашиваем фото из сети
    var imagesPost: [ImgaePost]? {get set} //сохраняем полученные фото
    
}

class ImagesPresenter: ImagesViewPresenterProtocol {
   
    weak var view: ImagesViewProtocol?
    let networkService: NetworckServiceProtocol!
    var imagesPost: [ImgaePost]?
    let cache = NSCache<NSNumber, UIImage>()
    
    required init (view: ImagesViewProtocol, networkService: NetworckServiceProtocol) {
        
        self.view = view
        self.networkService = networkService
        getImages()
    }
    
   func getImages() {
       networkService.getImages { [weak self] result in
           guard let self = self else {return}
           DispatchQueue.main.async {
               switch result {
                          case .success(let imagesPost):
                              self.imagesPost = imagesPost
                              self.view?.succes()

                          case .failure(let error):
                              self.view?.failure(error: error)
                          }
           }

       }
   }
    
    
}
