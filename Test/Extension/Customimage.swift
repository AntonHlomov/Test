//
//  Customimage.swift
//  Test
//
//  Created by Anton Khlomov on 11/02/2022.
//

import Foundation
import UIKit

class CustomUIimageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure(){
       contentMode = .scaleAspectFill //.scaleAspectFit
       backgroundColor = .lightGray
       clipsToBounds = true
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
