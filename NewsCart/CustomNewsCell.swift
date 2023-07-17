//
//  CustomNewsCell.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 14/07/23.
//

import UIKit

class CustomNewsCell: UITableViewCell {

    
    @IBOutlet weak var newsTitle: UILabel!
    
    @IBOutlet weak var newsDescription: UILabel!
    
    @IBOutlet weak var newsSource: UILabel!
    
    @IBOutlet weak var newsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = contentView.frame.size.height/5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
