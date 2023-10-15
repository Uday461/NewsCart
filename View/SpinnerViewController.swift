//
//  SpinnerViewController.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 15/10/23.
//

import Foundation
import UIKit

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

       override func loadView() {
           view = UIView()
           view.backgroundColor = UIColor(white: 0, alpha: 0.4)

           spinner.translatesAutoresizingMaskIntoConstraints = false
           spinner.startAnimating()
           view.addSubview(spinner)

           spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       }
}
