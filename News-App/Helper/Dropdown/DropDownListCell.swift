//
//  DropDownListCell.swift
//  BottomSheetDropdown
//
//  Created by Jana's MacBook Pro on 3/14/24.
//

import Foundation
import UIKit

class DropDownListCell: UICollectionViewCell {
    
    lazy var titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var seperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(imgView)
        addSubview(titleLabel)
        addSubview(seperatorLine)
        imgView.anchor(top:safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: seperatorLine.topAnchor, right: titleLabel.leftAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 8, size: CGSize(width: 30, height: 20))
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: imgView.rightAnchor, bottom: seperatorLine.topAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 8, rightConstant: 12, size: .zero)
        seperatorLine.anchor(top: titleLabel.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, size: CGSize(width: .zero, height: 1))
    }
}



//MARK: - Setup Layout Anchor
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -rightConstant).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}
