//
//  ImgaePost.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//

import Foundation

struct ImgaePost: Decodable{
    var albumId: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
}
