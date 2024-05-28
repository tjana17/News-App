//
//  CategoryCell.swift
//  News-App
//
//  Created by DB-MBP-023 on 25/05/24.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var catagoryCollectionView: UICollectionView!
    
    var titleArr = ["Business", "Entertainment", "Health", "Science", "Sports", "Technology"]
    var getCategory: ((_: String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let category = UINib(nibName: "CategoriesCollectionCell", bundle: nil)
        catagoryCollectionView.register(category, forCellWithReuseIdentifier: "categoriesCell")
        catagoryCollectionView.dataSource = self
        catagoryCollectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - UICollectionView DataSource
extension CategoryCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as? CategoriesCollectionCell else { return UICollectionViewCell() }
        let items = titleArr[indexPath.item]
        cell.imageView.image = UIImage(named: items.lowercased())
        cell.titleLbl.text = items
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension CategoryCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getCategory?(titleArr[indexPath.item])
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CategoryCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 90)
    }
}

