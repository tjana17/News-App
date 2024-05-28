//
//  BusinessTableCell.swift
//  News-App
//
//  Created by DB-MBP-023 on 26/05/24.
//

import UIKit

class BusinessTableCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var articles = [Article]()
    var getDetailLink: ((_: String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        let business = UINib(nibName: "BusinessCollectionViewCell", bundle: nil)
        collectionView.register(business, forCellWithReuseIdentifier: "businessCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

//MARK: - UICollectionViewDataSource
extension BusinessTableCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "businessCollectionCell", for: indexPath) as? BusinessCollectionViewCell else { return UICollectionViewCell() }
        cell.titleLbl.text = articles[indexPath.item].title
        cell.imageView.downloaded(from: articles[indexPath.item].urlToImage ?? "")
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension BusinessTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(collectionView.frame.width / 2 - 18)
        return CGSize(width: width, height: 140)
    }
}

//MARK: - UICollectionViewDelegate
extension BusinessTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getDetailLink?(articles[indexPath.item].url)
    }
}
