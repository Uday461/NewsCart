//
//  HeaderView.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 16/07/23.
//

import Foundation
import UIKit
class HeaderView: UIView{
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet var contentView: UIView!
    
    var apiNewsManager = APINewsManager()

    var fetchCategoryNewsDelegate: fetchCategoryNews?
    
    @IBAction func businessButtonPressed(_ sender: UIButton) {
        apiNewsManager.performRequestForNews(urlString: "https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=2fa323dfd66b46a6a3f16e37f6dca6a6")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: UIView.noIntrinsicMetric, height: 190)
    }
    
    private func commonInit(){
        let bundle  = Bundle(for: HeaderView.self)
        bundle.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true

    }
}
