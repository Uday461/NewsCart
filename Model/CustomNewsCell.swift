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
    
    @IBOutlet weak var button: UIButton!
    
    var cellIndex: IndexPath?
    
    var clickDelegate: ClickDelegate?
    
    @IBAction func buttonTapped(_ sender: Any) {
        button.backgroundColor = .systemFill
        clickDelegate?.clicked(cellIndex!.row)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
