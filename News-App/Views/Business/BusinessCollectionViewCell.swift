//
//  BusinessCollectionViewCell.swift
//  News-App
//
//  Created by DB-MBP-023 on 26/05/24.
//

import UIKit

class BusinessCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    {
        didSet {
            imageView.addBlackGradientLayerInForeground(frame: CGRect(x: 0, y: 0, width: self.bounds.width + 10, height: self.bounds.height), colors: [.clear, .black])
            imageView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
