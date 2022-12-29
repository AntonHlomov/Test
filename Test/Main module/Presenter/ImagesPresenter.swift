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
    func reloadCV()
    func failure(error: Error)
    
}
protocol ImagesViewPresenterProtocol: AnyObject {
    init(view: ImagesViewProtocol, networkService: NetworckServiceProtocol,dataLinks:[String])
    
    var linksMain:[String?] { get set }
    func reloadDataLinks()
    func removeImagePost(indexPath: IndexPath)
    func getData(indexPath: IndexPath,completion: @escaping (ImgaePost?) -> ())
}

class ImagesPresenter: ImagesViewPresenterProtocol {
 
    weak var view: ImagesViewProtocol?
    let networkService: NetworckServiceProtocol!
    var dataLinks:[String]
    var linksMain = [String?]()
    
    required init (view: ImagesViewProtocol, networkService: NetworckServiceProtocol, dataLinks: [String]) {
        self.view = view
        self.networkService = networkService
        self.dataLinks = dataLinks
        self.linksMain = dataLinks
    }
    func getData(indexPath: IndexPath,completion: @escaping (ImgaePost?) -> ()) {
        guard let link = linksMain[indexPath.item] else {return}
        networkService.getImage(link: link) { [weak self] result in
            guard self != nil else {return}
            DispatchQueue.main.async { [self] in
                switch result{
                case .success(let imagePost):
                    guard let imagePost = imagePost else {return}
                    completion(imagePost)
                case .failure(let error):
                    self?.view?.failure(error: error)
                }
            }
        }
    }

    func removeImagePost(indexPath: IndexPath){
        guard let link = linksMain[indexPath.item] else {return}
        guard imagePostCache[link] == nil else {
            imagePostCache.removeValue(forKey: link)
            self.linksMain.remove(at: indexPath.item)
            return}
        self.linksMain.remove(at: indexPath.item)
    }
    
    func reloadDataLinks(){
        imagePostCache.removeAll()
        self.linksMain = dataLinks
        self.view?.reloadCV()
    }
    
}
