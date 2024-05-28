//
//  CategoriesCollectionCell.swift
//  News-App
//
//  Created by DB-MBP-023 on 25/05/24.
//

import UIKit

class CategoriesCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 10
            imageView.addBlackGradientLayerInForeground(frame: self.bounds, colors: [.clear, .black])
        }
    }
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

