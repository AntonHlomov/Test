//
//  CellImage.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//

import UIKit

class CellImage: UICollectionViewCell {

    override init(frame: CGRect) {
        super .init(frame: frame)
        setupViews()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.postImageView.image = nil
    }
                  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let postImageView = CustomUIimageView(frame: .zero )
  
    func setupViews(){
        
    addSubview(postImageView)
        postImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, pading:.init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))

    }
}
