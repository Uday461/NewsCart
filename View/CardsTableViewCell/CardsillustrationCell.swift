//
//  CardsillustrationCell.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 01/09/23.
//

import UIKit

class CardsillustrationCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var buttonCTA: UIButton!
    var cellIndex: IndexPath?
    var clickDelegate: ClickDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonCTAPressed(_ sender: Any) {
        clickDelegate?.clicked(cellIndex!.row, "")
    }

}
