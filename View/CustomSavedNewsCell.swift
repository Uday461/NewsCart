//
//  CustomSavedNewsCell.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 18/07/23.
//

import Foundation
import UIKit
class CustomSavedNewsCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var newsImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
