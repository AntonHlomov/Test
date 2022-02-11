//
//  ImagesPresenter.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//

import Foundation
import UIKit


protocol ImagesViewProtocol: AnyObject {
    func deleteCell(indexPath: IndexPath)
}

protocol ImagesViewPresenterProtocol: AnyObject {
    init(view: ImagesViewProtocol, networkService: NetworckServiceProtocol)
    
    var cache: NSCache<NSNumber, UIImage> { get set } //сохраняем полученное фото в кеш
    var countCell: Int{ get set }
    
    func loadImage(completion: @escaping (UIImage?) -> ()) // api
    func checkCache(itemNumber: NSNumber,completion: @escaping (UIImage?) -> ()) // запрашиваем фото из сети
    func updateCache (indexPath: IndexPath)
 
}

class ImagesPresenter: ImagesViewPresenterProtocol {
 
    weak var view: ImagesViewProtocol?
    let networkService: NetworckServiceProtocol!
    var cache = NSCache<NSNumber, UIImage>()
    var countCell = 6
   
    required init (view: ImagesViewProtocol, networkService: NetworckServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    // MARK: - Api
    func loadImage(completion: @escaping (UIImage?) -> ()) {
        networkService.loadImage{ [] (image) in
            guard  let image = image else { return }
            DispatchQueue.main.async { [] in
                completion(image)
            }
        }
    }
    // MARK: - Проверка есть ли фотография в кеше если нет то дабавить
    func checkCache(itemNumber: NSNumber,completion: @escaping (UIImage?) -> ()) {
      if let image = self.cache.object(forKey: itemNumber) {
          DispatchQueue.main.async {
          completion(image)
          }
        } else {
            self.loadImage { [weak self] (image) in
                guard let self = self, let image = image else { return }
               // cell.postImageView.image = image
                DispatchQueue.main.async {
                completion(image)
                }
                self.cache.setObject(image, forKey: itemNumber)
            }
        }
    }
    // MARK: - Удаление ячейки. Обнавление кеша и количества ячеек
    func updateCache (indexPath: IndexPath){
        let itemNumber = NSNumber(value: indexPath.item)
        self.cache.removeObject(forKey: itemNumber)
        self.countCell -= 1
        
        if self.countCell > 1 && indexPath.item != self.countCell {
            
            for index in indexPath.item...self.countCell-1 {
              let itemNumber = NSNumber(value: index)
                
              guard self.cache.object(forKey: NSNumber(value: index + 1)) != nil else {
                  self.cache.removeObject(forKey:NSNumber(value: index))
                  self.view?.deleteCell(indexPath: indexPath)
                  return
              }
                
              let image = self.cache.object(forKey: NSNumber(value: index + 1))
              self.cache.setObject(image!, forKey: itemNumber)
          }
        }
        self.view?.deleteCell(indexPath: indexPath)
        }
    
    
    
    
}
