//
//  HeadlinesCollectionCell.swift
//  News-App
//
//  Created by DB-MBP-023 on 25/05/24.
//

import UIKit

class HeadlinesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 20
            imageView.addBlackGradientLayerInForeground(frame: CGRect(x: 0, y: 0, width: self.bounds.width + 25, height: self.bounds.height), colors: [.clear, .black])
        }
    }
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorView: UIView! {
        didSet {
            authorView.layer.cornerRadius = 10
            authorView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var authorLbl: UILabel! 
    @IBOutlet weak var sourceLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
