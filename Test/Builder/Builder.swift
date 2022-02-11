//
//  Builder.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//

import  UIKit

protocol Builder{
    static func mainModule() -> UIViewController
}

class ModelBuilder: Builder{
    
    static func mainModule() -> UIViewController {
     
        let view = ImagesController()
        let networkService = NetworkService()
        let presenter = ImagesPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
  }
}
