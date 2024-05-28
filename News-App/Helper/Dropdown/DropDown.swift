//
//  DropDown.swift
//  BottomSheetDropdown
//
//  Created by Jana's MacBook Pro on 3/14/24.
//

import Foundation
import UIKit

class DropDown : NSObject, UICollectionViewDelegateFlowLayout {
    
    //Variable Initializers
    private let backgroundView = UIView()
    static private let cellHeight: CGFloat = 50
    private let cellIdentifier : String = "ListCell"
    
    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: DropDown.cellHeight)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        
        return collection
    }()
    
    var completion: ((Int)-> Void)?
    
    var itemsArray : [String] = []
    var imagesArray: [String] = []
    var selectedIndex = -1
    
    //MARK: - Init
    override init() {
        super.init()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(DropDownListCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    
    @objc func handleDismiss() {
        //Dismiss List
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseIn,
                           animations: {
                            self.backgroundView.alpha = 0.0
                            self.collectionView.frame = CGRect(x: 0,
                                                               y: window.frame.height,
                                                               width: self.collectionView.frame.width,
                                                               height: self.collectionView.frame.height)
            }, completion: { _ in
                if let handler = self.completion {
                    handler(self.selectedIndex)
                }
            })
        }
    }
    
}

//MARK: - ListView
extension DropDown {
    
    //MARK: - Launch List for bottom
    func launchList(itemsArray list: [String], imagesArray imgList:[String], completionHandler: @escaping(Int) -> Void) {
        
        if let window = UIApplication.shared.keyWindow {
            
            self.selectedIndex = -1
            self.completion = completionHandler
            self.itemsArray = list
            self.imagesArray = imgList
            self.collectionView.reloadData()
            
            backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            backgroundView.alpha = 0.0
            [backgroundView, collectionView].forEach{ window.addSubview($0) }
            
            backgroundView.frame = window.frame
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            var height = (CGFloat(itemsArray.count) * DropDown.cellHeight + 30)
            
            if height > window.frame.width {
                height = window.frame.width
            }
            
            collectionView.frame = CGRect(x: 0,
                                          y: window.frame.height,
                                          width: window.frame.width,
                                          height: height)
            collectionView.layer.cornerRadius = 10
            UIView.animate(withDuration: 0.7,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                            self.backgroundView.alpha = 1.0
                            self.collectionView.frame = CGRect(x: 0,
                                                               y: window.frame.height - height,
                                                               width: self.collectionView.frame.width,
                                                               height: self.collectionView.frame.height)
                            
            }, completion: nil)
        }
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension DropDown : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? DropDownListCell else { return UICollectionViewCell() }
        cell.imgView.image = UIImage(named: imagesArray[indexPath.row])
        cell.titleLabel.text = itemsArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            cell?.backgroundColor = UIColor(white: 1, alpha: 1.0)
        }
        self.selectedIndex = indexPath.item
        self.perform(#selector(self.handleDismiss), with: nil, afterDelay: 0.1)
    }
}
