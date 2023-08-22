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
    
    var cellIndex: IndexPath?
    
    @IBOutlet weak var saveImageView: UIImageView!
    
    var clickDelegate: ClickDelegate?
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if (saveImageView.image == UIImage(systemName: Identifiers.systemName.bookmarkfill)){
            saveImageView.image = UIImage(systemName: Identifiers.systemName.bookmark)
            clickDelegate?.clicked(cellIndex!.row, Identifiers.unsave)
        } else{
            saveImageView.image = UIImage(systemName: Identifiers.systemName.bookmarkfill)
            clickDelegate?.clicked(cellIndex!.row, Identifiers.save)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
