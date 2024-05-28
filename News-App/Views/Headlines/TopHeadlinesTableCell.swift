//
//  TopHeadlinesTableCell.swift
//  News-App
//
//  Created by DB-MBP-023 on 25/05/24.
//

import UIKit

class TopHeadlinesTableCell: UITableViewCell {

    @IBOutlet weak var headlinesCollectionView: UICollectionView!
    
    var articles = [Article]()
    var getDetailLink: ((_: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let categoriesCell = UINib(nibName: "HeadlinesCollectionCell", bundle: nil)
        headlinesCollectionView.register(categoriesCell, forCellWithReuseIdentifier: "headlinesCell")
        headlinesCollectionView.dataSource = self
        headlinesCollectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - UICollectionView DataSource
extension TopHeadlinesTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headlinesCell", for: indexPath) as? HeadlinesCollectionCell else { return UICollectionViewCell() }
        cell.imageView.downloaded(from: articles[indexPath.item].urlToImage ?? "")
        cell.titleLbl.text = articles[indexPath.item].title
        cell.sourceLbl.text = articles[indexPath.item].source.name
        let publishedDate = articles[indexPath.item].publishedAt
        let splitDate = publishedDate?.components(separatedBy: "T")
        let formattedDate = splitDate?[0].formattedDate
        cell.authorLbl.text = formattedDate
        return cell
    }
}

//MARK: - UICollectionViewFlowDelegateLayout
extension TopHeadlinesTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(collectionView.frame.width - 40)
        return CGSize(width: width, height: 360)
    }
}

//MARK: - UICollectionViewDelegate
extension TopHeadlinesTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getDetailLink?(articles[indexPath.item].url)
    }
}
