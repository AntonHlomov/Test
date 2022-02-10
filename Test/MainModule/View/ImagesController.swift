//
//  ImagesController.swift
//  Test
//
//  Created by Anton Khlomov on 08/02/2022.
//

import UIKit

let cellId = "apCellId"

class ImagesController: UIViewController,UINavigationControllerDelegate {

    private var cache = NSCache<NSNumber, UIImage>()

   // private var deleteIndexPathItemsСache = NSCache<NSNumber, UIImage>()
    
   
    var presenter: ImagesViewPresenterProtocol!
    var countCell = 50
   // var countCache = 0
    
   
    
    let colectionView: UICollectionView = {
        
    let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
     //  layout.scrollDirection = .vertical
        let screenWidth = UIScreen.main.bounds.width
        let widthHeightConstant = UIScreen.main.bounds.width - 20 // / 2.2
        layout.itemSize = CGSize(width: widthHeightConstant,
                                 height: widthHeightConstant)
        let numberOfCellsInRow = floor(screenWidth / widthHeightConstant)
        let inset = (screenWidth - ( widthHeightConstant)) / (numberOfCellsInRow + 10)
      
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
       // layout.minimumInteritemSpacing = 10
       // layout.minimumLineSpacing = 10
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .gray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    return collectionView
}()

    override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = .red
        cache.countLimit = countCell
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
    // MARK: - свайп вниз для обновления
    lazy var dataRefresher : UIRefreshControl = {
    let myRefreshControl = UIRefreshControl()

    // Изменить цвет ActivityIndicator
    myRefreshControl.tintColor =  .white
    myRefreshControl.backgroundColor = .clear
    // Добавление действия при обновлении
    myRefreshControl.addTarget(self, action: #selector(updateMyCollectionView), for: .valueChanged)
    return myRefreshControl
    }()
    
    
    @objc func updateMyCollectionView() {
        self.cache.removeAllObjects()
       // self.deleteIndexPathItemsСache.removeAllObjects()
        self.countCell = 6
     //   self.countCache = 0
        // Завершить обновление
        dataRefresher.endRefreshing()
       // presenter.getImages()
        colectionView.reloadData()
        print("обновление")
    }
    
    fileprivate func configureViewComponents(){
        view.addSubview(colectionView)
        colectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width, height: view.frame.height ))
    }
    // MARK: - Image Loading
    private func loadImage(completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            let url = URL(string: "https://picsum.photos/800")!
            
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
}

extension ImagesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countCell
    }
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize (width: view.frame.width - 20, height: view.frame.width - 20)
   }
   // убераем разрыв между вью по горизонтали
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 10
   }
   // убераем разрыв между вью по вертикали
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
   }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CellImage
        return cell
    }
    // MARK: - UICollectionView Delegate
     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         
        guard let cell = cell as? CellImage else { return }
        let itemNumber = NSNumber(value: indexPath.item)
        // guard self.deleteIndexPathItemsСache.object(forKey: itemNumber) == nil else {return}
         
        if let cachedImage = self.cache.object(forKey: itemNumber) {
            print("Кеш фото: \(itemNumber)")
            cell.postImageView.image = cachedImage
          
        } else {
            self.loadImage { [weak self] (image) in
                guard let self = self, let image = image else { return }
               // self.countCache+=1
                cell.postImageView.image = image
                self.cache.setObject(image, forKey: itemNumber)
            }
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("нажал\(indexPath)")
    
        let cell = collectionView.cellForItem(at: indexPath)
        
   //     UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
   //         cell!.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
   //     }, completion: { finished in
   //       print("ушла")
   //         let itemNumber = NSNumber(value: indexPath.item)
   //         guard let image = self.cache.object(forKey: NSNumber(value: indexPath.item)) else {return}
   //         self.deleteIndexPathItemsСache.setObject(image, forKey: itemNumber)
   //         collectionView.deleteItems(at: [indexPath])
   //     } )
     
 
        
       UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: [],
                  animations: {
          // cell!.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
           cell!.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
          
           print("ушел")
  
                  },
                      completion: { finished in
           UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseIn,
                          animations: { [] in
  
                cell!.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
               
               let itemNumber = NSNumber(value: indexPath.item)
               self.cache.removeObject(forKey: itemNumber)
               self.countCell = self.countCell - 1
               if  self.countCell > 1 && indexPath.item != self.countCell  {
                   for index in indexPath.item...self.countCell-1 {
                     let itemNumber = NSNumber(value: index)
                     guard self.cache.object(forKey: NSNumber(value: index + 1)) != nil else{
                         self.cache.removeObject(forKey:NSNumber(value: index))
                         collectionView.deleteItems(at: [indexPath])
                       //  collectionView.reloadItems(at: [[0, index]])
                         return}
                     let image = self.cache.object(forKey: NSNumber(value: index + 1))
                     self.cache.setObject(image!, forKey: itemNumber)
                 }
               }
              
               collectionView.deleteItems(at: [indexPath])
              // collectionView.reloadItems(at: [[0, indexPath.item+1]])
  
               
               
               
            //   let itemNumber = NSNumber(value: indexPath.item)
            //   guard let image = self.cache.object(forKey: NSNumber(value: indexPath.item)) else {return}
            //   self.deleteIndexPathItemsСache.setObject(image, forKey: itemNumber)
            //   self.cache.removeObject(forKey: itemNumber)
            //   collectionView.deleteItems(at: [indexPath])
            //   self.countCell -= 1
            //   collectionView.reloadData()
                              },
                              completion: nil
                          )
  
                      }
                  )
  
      
        
        
        
        
        
        
     
       
           
       

        
        
       
     
        
        
    }
}

extension ImagesController: ImagesViewProtocol{
    
    func succes() {
        colectionView.reloadData()
    }
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}
