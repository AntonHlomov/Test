//
//  Builder.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//

import  UIKit

// test data
let dataLinks =  ["https://picsum.photos/id/133/800","https://picsum.photos/id/228/800","https://picsum.photos/id/281/800","https://picsum.photos/id/314/800","https://picsum.photos/id/258/800","https://picsum.photos/id/238/800"]

protocol Builder{
    static func mainModule() -> UIViewController
}

class ModelBuilder: Builder{
    static func mainModule() -> UIViewController {
        let view = ImagesController()
        let networkService = NetworkService()
        let presenter = ImagesPresenter(view: view, networkService: networkService, dataLinks: dataLinks)
        view.presenter = presenter
        return view
  }
}
