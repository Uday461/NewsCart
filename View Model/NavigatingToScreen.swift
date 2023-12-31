//
//  NavigatingToScreen.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 29/08/23.
//

import Foundation
import UIKit
class NavigatingToScreen{
    static func navigatingToOtherScreen(toScreen: String){
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                return
            }
           
            guard let navigationVC = rootViewController as? UINavigationController else {
                return
            }
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            if (toScreen == "NewsSavedVC"){
                if let newsSavedVC = storyBoard.instantiateViewController(withIdentifier: "NewsSavedVC") as? NewsSavedVC{
                    let coreDataManager = CoreDataManager()
                    let articles = coreDataManager.loadArticles()
                    navigationVC.pushViewController(newsSavedVC, animated: true)
                }
            }
        
        }
    }
}
