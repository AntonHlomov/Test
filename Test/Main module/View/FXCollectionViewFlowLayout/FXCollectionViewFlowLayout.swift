//
//  FXCollectionViewFlowLayout.swift
//  Test
//
//  Created by Anton Khlomov on 29/12/2022.
//

import Foundation
import UIKit

class FXCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        attribute?.transform = CGAffineTransform(translationX: 500.0,y: 0)
        attribute?.alpha = 0.0
        return attribute
    }
}
