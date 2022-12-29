//
//  ImagesController.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//
/*
   The prologue:
   Application in Swift (SwiftUI) for iPhone without using Interface Builder and SwiftUI, version iOS 10.0+, without using third-party frameworks, only iOS SDK.
 1) Application based on UINavigationController with support for horizontal and vertical orientation.
 2) A UICollectionView is placed in the ViewController, the number of cells is 6, the cell width is the width of the screen with fields of 10 pixels on all sides.  The height of the cell is equal to the width.
 3) Each cell is loaded asynchronously as needed (when it appears on the screen) pictures from the Internet (800 pixels wide and 600 high).
 4) If the image has loaded at least once, then it is shown later even without an Internet connection (offline cache).
 5) When you click on a cell in which the picture has already loaded, the cell will animate to the right to the end of the screen, after which all the remaining cells from the bottom will animate up one cell to take the place of the deleted cell.
 6) A "pull-to-refresh" control has been added to the UICollectionView, which, when activated, completely restores the original state of the UICollectionView and reloads all previously downloaded images.

  Коментарий:
  В качестве API используеться сервис "https://picsum.photos/".
*/

import UIKit

class ImagesController: UIViewController,UINavigationControllerDelegate {
    var presenter: ImagesViewPresenterProtocol!
    let cellId = "apCellId"
    var colectionView: UICollectionView = {
        let layout = FXCollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let screenWidth = UIScreen.main.bounds.width
        let widthHeightConstant = UIScreen.main.bounds.width - 20
        let numberOfCellsInRow = floor(screenWidth / widthHeightConstant)
        let inset = (screenWidth - ( widthHeightConstant)) / (numberOfCellsInRow + 10)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .gray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        layout.itemSize = CGSize(width: widthHeightConstant, height: widthHeightConstant)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title  = "Picsum"
        settingColectionView()
        configureViewComponents()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        colectionView.collectionViewLayout.invalidateLayout()
    }
    func settingColectionView(){
        colectionView.delegate = self
        colectionView.dataSource = self
        colectionView.register(CellImage.self, forCellWithReuseIdentifier: cellId)
        colectionView.refreshControl = dataRefresher
    }
    // MARK: - RefreshControl
    lazy var dataRefresher : UIRefreshControl = {
    let myRefreshControl = UIRefreshControl()
    myRefreshControl.tintColor =  .white
    myRefreshControl.backgroundColor = .clear
    myRefreshControl.addTarget(self, action: #selector(updateMyCollectionView), for: .valueChanged)
    return myRefreshControl
    }()
    @objc func updateMyCollectionView() {
        self.presenter.reloadDataLinks()
        dataRefresher.endRefreshing()
    }
    // MARK: - Configure components
    fileprivate func configureViewComponents(){
        view.addSubview(colectionView)
        colectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width, height: view.frame.height ))
    }
}
    // MARK: - ImagesViewProtocol
extension ImagesController: ImagesViewProtocol{
    func failure(error: Error) {
        let error = "\(error.localizedDescription)"
        self.alertMassage(title: "Ops!", message: error)
    }
    func reloadCV() {
        self.colectionView.reloadData()
    }
    func deleteCell(indexPath: IndexPath) {
        colectionView.deleteItems(at: [indexPath])
    }
}
