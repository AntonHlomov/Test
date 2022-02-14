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
    func reloadCollectionView()
}

protocol ImagesViewPresenterProtocol: AnyObject {
    init(view: ImagesViewProtocol, networkService: NetworckServiceProtocol,dataLinks:[String])
    
    var cache: NSCache<NSNumber, ImgaePost> { get set } //сохраняем полученное фото в кеш
    var links:[String] { get set }
    func loadImage(link: String,completion: @escaping (ImgaePost?) -> ()) // api
    func checkCache(indexPath: IndexPath,completion: @escaping (ImgaePost?) -> ()) // запрашиваем фото из сети
    func updateCache (indexPath: IndexPath)
    func reloadDataLinks()
  
}

class ImagesPresenter: ImagesViewPresenterProtocol {
 
    weak var view: ImagesViewProtocol?
    let networkService: NetworckServiceProtocol!
    var cache = NSCache<NSNumber, ImgaePost>()
    var dataLinks:[String]
    var links = [String]()

    required init (view: ImagesViewProtocol, networkService: NetworckServiceProtocol,dataLinks: [String]) {
        self.view = view
        self.networkService = networkService
        self.dataLinks = dataLinks
        self.links = dataLinks

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
        self.view?.deleteCell(indexPath: indexPath)
        guard links.indices.contains(indexPath.item) == true else {return}
        self.links.remove(at: indexPath.item)
     }
    
    func reloadDataLinks(){
        self.cache.countLimit = self.links.count // Лимит кеша связан с количеством ячеек cell
        self.cache.removeAllObjects()
        self.links = self.dataLinks
        self.view?.reloadCollectionView()
    }
    
}
