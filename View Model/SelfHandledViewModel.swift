//
//  SelfHandledViewModel.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 07/09/23.
//

import Foundation
import MoEngageCards

class SelfHandledViewModel{
    var selfHandledModel = [SelfHandledModel]()
    init(selfHandledModel: [SelfHandledModel] = [SelfHandledModel]()) {
        self.selfHandledModel = selfHandledModel
    }
    func getSelfHandledVM()->[SelfHandledModel]{
        return selfHandledModel
    }
}
