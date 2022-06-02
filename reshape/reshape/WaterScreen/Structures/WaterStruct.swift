//
//  WaterStruct.swift
//  reshape
//
//  Created by Иван Фомин on 28.05.2022.
//

import Foundation

struct WaterStruct {
    var water: Int
    var coffee: Int
    var tea: Int
    var fizzy: Int
    var milk: Int
    var alcohol: Int
    var juice: Int
    var weight: Double
    
    init() {
        water = 0
        coffee = 0
        tea = 0
        fizzy = 0
        milk = 0
        alcohol = 0
        juice = 0
        weight = -1
    }
    
    init(water: Int, coffee: Int, tea: Int, fizzy: Int, milk: Int, alcohol: Int, juice: Int, weight: Double = -1) {
        self.water = water
        self.coffee = coffee
        self.tea = tea
        self.fizzy = fizzy
        self.milk = milk
        self.alcohol = alcohol
        self.juice = juice
        self.weight = weight
    }
    
    func total() -> Int {
        let sum = water + coffee + tea + fizzy + milk + alcohol + juice
        return sum
    }
}
