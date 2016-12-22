//
//  ItemCollectionViewCell.swift
//  dribbbleDemo
//
//  Created by rin on 2016/12/21.
//  Copyright © 2016年 rin. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var editorNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.cornerRadius = 5
        bgView.layer.borderColor = UIColor.gray.cgColor
        bgView.layer.borderWidth = 1.0
        avatarImageView.layer.cornerRadius = 20
    }

}
