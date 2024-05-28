//
//  CategoriesListCell.swift
//  News-App
//
//  Created by DB-MBP-023 on 27/05/24.
//

import UIKit

class CategoriesListCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!{
        didSet {
            newsImage.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var actionView: UIView! {
        didSet {
            actionView.layer.cornerRadius = actionView.frame.size.width / 2
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
