//
//  ExtansionCollectionImage.swift
//  Test
//
//  Created by Anton Khlomov on 29/12/2022.
//
import Foundation
import UIKit

extension ImagesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  presenter.linksMain.count     //presenter.links.count 
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: view.frame.width - 20, height: view.frame.width - 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CellImage
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("обновим", indexPath.item)
        guard let cell = cell as? CellImage else { return }
        self.presenter.getData(indexPath: indexPath){ [] (imgaePost) in
              guard let imgaePost = imgaePost else {return}
              cell.postImageView.image = imgaePost.photo
          }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates({ () -> Void in
            self.presenter.removeImagePost(indexPath: indexPath)
            collectionView.deleteItems(at: [indexPath])
        }, completion:nil)
    }
}
