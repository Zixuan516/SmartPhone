//
//  StockData.swift
//  StockUpdate
//
//  Created by Ashish Ashish on 10/1/20.
//

import Foundation
import RealmSwift

class StockData: Object{
    @objc dynamic var symbol : String! = ""
    @objc dynamic var price : Double = 0.0
    @objc dynamic var volume : Int64 = 0
    
    init(symbol: String!, price: Double, volume: Int64) {
        super.init()
        self.symbol = symbol
        self.price = price
        self.volume = volume
    }
    
    required init() {
        
    }
    
    override static func primaryKey() -> String? {
          return "symbol"
    }
}
