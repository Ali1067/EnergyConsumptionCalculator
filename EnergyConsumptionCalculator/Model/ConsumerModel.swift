//
//  ConsumerModel.swift
//  EnergyConsumptionCalculator
//
//  Created by M.Ali on 20/08/2022.
//

import Foundation

class ConsumerModel {
    private var id: String?
    
    
    init(dbModel: Consumer) {
        self.id = String(dbModel.id)
    }
    
    class func convertIntoModel(dbModelList: [Consumer]) -> [ConsumerModel] {
        var list = [ConsumerModel]()
        for item in dbModelList {
            list.append(ConsumerModel(dbModel: item))
        }
        return list
    }
}
