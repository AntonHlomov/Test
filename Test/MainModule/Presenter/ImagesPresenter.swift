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
    
    var cache: NSCache<NSNumber, ImgaePost> { get set } //сохраняем полученное фото в кеш
    var countCell: Int{ get set }
    
    func loadImage(link: String,completion: @escaping (ImgaePost?) -> ()) // api
    func checkCache(indexPath: IndexPath,completion: @escaping (ImgaePost?) -> ()) // запрашиваем фото из сети
    func updateCache (indexPath: IndexPath)
    
    
 
}

class ImagesPresenter: ImagesViewPresenterProtocol {
 
    weak var view: ImagesViewProtocol?
    let networkService: NetworckServiceProtocol!
    var cache = NSCache<NSNumber, ImgaePost>()
    var links =  ["https://picsum.photos/id/1070/800","https://picsum.photos/id/228/800","https://picsum.photos/id/281/800","https://picsum.photos/id/314/800","https://picsum.photos/id/258/800","https://picsum.photos/id/238/800"]
   // var links = [String]()
    var countCell: Int
    
    
    required init (view: ImagesViewProtocol, networkService: NetworckServiceProtocol) {
        self.view = view
        self.networkService = networkService
        self.countCell = links.count
        self.links = [String]()
        
    }
    // MARK: - Запрос к серверу.
    func loadImage(link: String,completion: @escaping (ImgaePost?) -> ()) {
        networkService.loadImage(link: link){ [] (image) in
            guard  let image = image else { return }
            DispatchQueue.main.async { [] in
                completion(image)
            }
        }
    }
    // MARK: - Проверка есть ли фотография в кеше, если нет то дабавить.
    func checkCache(indexPath: IndexPath,completion: @escaping (ImgaePost?) -> ()) {
      guard links.indices.contains(indexPath.item) == true else {
          return}
      let keyLink = links[indexPath.item].hashValue
      let itemNumber = NSNumber(value: keyLink)
        
        
     
        
        
      if let image = self.cache.object(forKey: itemNumber) {
          DispatchQueue.main.async {
          completion(image)
          }
        } else {
            guard links.indices.contains(indexPath.item) == true else {return}
            self.loadImage (link: links[indexPath.item]){ [weak self] (image) in
              
                guard let self = self, let image = image else { return }
             
                DispatchQueue.main.async {
                completion(image)
                }
                self.cache.setObject(image, forKey: itemNumber)
            }
        }
    }
    // MARK: - Удаление ячейки. Обнавление кеша и количества ячеек.
    func updateCache (indexPath: IndexPath){
        guard links.indices.contains(indexPath.item) == true else {return}
        let keyLink = links[indexPath.item].hashValue
        let itemNumber = NSNumber(value: keyLink)
        
        guard self.cache.object(forKey:itemNumber) != nil else {return}
        self.cache.removeObject(forKey:itemNumber)
        guard links.indices.contains(indexPath.item) == true else {return}
        self.links.remove(at: indexPath.item)
      //  self.view?.deleteCell(indexPath: indexPath)
     
        self.view?.deleteCell(indexPath: indexPath)
        self.countCell = self.links.count
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
  //      guard links.indices.contains(indexPath.item) == true else {return}
  //      print("до количество ячеек", self.countCell)
  //      let itemNumber = NSNumber(value: indexPath.item)
  //      self.cache.removeObject(forKey: itemNumber)
  //      self.links.remove(at: indexPath.item)
  //    //  if self.countCell != 1 { self.countCell -= 1}
  //
  //      if self.countCell > 1 && indexPath.item != self.countCell {
  //
  //          for index in indexPath.item...self.countCell-1 {
  //            let itemNumber = NSNumber(value: index)
  //
  //            guard self.cache.object(forKey: NSNumber(value: index + 1)) != nil else {
  //                self.cache.removeObject(forKey:NSNumber(value: index))
  //                self.view?.deleteCell(indexPath: indexPath)
  //              //  self.countCell -= 1
  //                self.countCell = self.links.count
  //                return
  //            }
  //
  //            let image = self.cache.object(forKey: NSNumber(value: index + 1))
  //            self.cache.setObject(image!, forKey: itemNumber)
  //        }
  //      }
  //      self.view?.deleteCell(indexPath: indexPath)
  //     // self.countCell -= 1
  //      self.countCell = self.links.count
     }
}
