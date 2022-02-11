//
//  ImagesController.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//
//  Задание:
//  Разработать приложение на Swift / Objective-C (SwiftUI не использовать) для iPhone без использования Interface Builder и SwiftUI, версия iOS 10.0+, без использования сторонних фреймворков, только iOS SDK.
//  1) Необходимо создать приложение, основанное на UINavigationController, с поддержкой горизонтальной и вертикальной ориентации.
//  2) Во ViewController'е разместить UICollectionView, количество ячеек - 6, ширина ячейки - ширина экрана с полями по 10 пикселей со всех сторон. Высота ячейки равна ширине.
//  3) В каждую ячейку загрузить асинхронно по мере необходимости (при появлении на экране) картинку с Интернета (любую, но не меньше 800 пикселей в ширину и 600 в высоту).
//  4) Если картинка хоть раз загрузилась, то она должна показываться потом даже без соединения с Интернетом (оффлайн кэш).
//  5) При нажатии на ячейку, в которой уже загрузилась картинки, ячейка должна анимированно уезжать вправо до конца экрана, после чего все оставшиеся снизу ячейки должны сдвинуться     анимированно вверх на одну ячейку, чтобы занять место удаленной ячейки.
//  6) Добавить к UICollectionView контролл "pull-to-refresh", который при активации должен полностью восстановить исходное состояние UICollectionView и заново загружать все скачанные     ранее картинки (восстанавливать состояние можно без анимации).
//
//  Коментарий:
//  В качестве API используеться сервис "https://picsum.photos/". Который отдает рандомно,в любом размере,по одной фотографии. Для изменения размера фотографии,нужно заменить значение /800 в  NetworkService -> func loadImage.
//  Количество фотографий изменяеться в ImagesPresenter -> countCell

import UIKit
let cellId = "apCellId"

class ImagesController: UIViewController,UINavigationControllerDelegate {
    var presenter: ImagesViewPresenterProtocol!
  
    let colectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let screenWidth = UIScreen.main.bounds.width
        let widthHeightConstant = UIScreen.main.bounds.width - 20
        layout.itemSize = CGSize(width: widthHeightConstant,
                                 height: widthHeightConstant)
        let numberOfCellsInRow = floor(screenWidth / widthHeightConstant)
        let inset = (screenWidth - ( widthHeightConstant)) / (numberOfCellsInRow + 10)
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .gray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    return collectionView
}()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title  = "Picsum"
       
        presenter.cache.countLimit = presenter.countCell // Лимит кеша связан с количеством ячеек cell
        colectionView.delegate = self
        colectionView.dataSource = self
        colectionView.register(CellImage.self, forCellWithReuseIdentifier: cellId)
        colectionView.refreshControl = dataRefresher
        configureViewComponents()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        colectionView.collectionViewLayout.invalidateLayout()
    }
    // MARK: - RefreshControl
    
    lazy var dataRefresher : UIRefreshControl = {
    let myRefreshControl = UIRefreshControl()
    myRefreshControl.tintColor =  .white // Изменить цвет activityIndicator
    myRefreshControl.backgroundColor = .clear
    myRefreshControl.addTarget(self, action: #selector(updateMyCollectionView), for: .valueChanged) // Добавление действия при обновлении
    return myRefreshControl
    }()
    
    @objc func updateMyCollectionView() {
        presenter.cache.countLimit = presenter.countCell // Лимит кеша связан с количеством ячеек cell
        self.presenter.cache.removeAllObjects()
        self.presenter.countCell = 6 // Обновление количества ячеек
        dataRefresher.endRefreshing() // Завершить обновление
        colectionView.reloadData()
    }
    
    // MARK: - Configure components
    
    fileprivate func configureViewComponents(){
        view.addSubview(colectionView)
        colectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width, height: view.frame.height ))
    }
}
    // MARK: - UICollectionView DelegateFlowLayout,WillDisplay

extension ImagesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.countCell
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
        
        guard let cell = cell as? CellImage else { return }
        let itemNumber = NSNumber(value: indexPath.item)
        
        self.presenter.checkCache(itemNumber: itemNumber)  { []  (image) in
            guard let image = image else { return }
           
            cell.image = image
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 11, initialSpringVelocity: 0, options: [],animations: {
           cell!.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width*2, y: 0)
           
          
       },
                      completion: { finished in
           UIView.animate(withDuration: 0.3, delay: 1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .curveEaseIn,animations: { [self] in
               cell!.transform = CGAffineTransform(translationX: 0, y: 0)
               self.presenter.updateCache(indexPath: indexPath)
                   }, completion: nil
               )
           }
       )
    }
}
    // MARK: - ImagesViewProtocol

extension ImagesController: ImagesViewProtocol{
    func deleteCell(indexPath: IndexPath) {
    colectionView.deleteItems(at: [indexPath])
    }
}
