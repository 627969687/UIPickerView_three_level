//
//  Model.swift
//  UIPickerView_three_level
//
//  Created by kuyou1 on 2018/2/5.
//  Copyright © 2018年 kuyou. All rights reserved.
//

import UIKit

struct Model: Codable {
    var resultCode:Int
    var resultInfo:[ProvinceModel]?
}

struct ProvinceModel: Codable {
    var name:String
    var children:[CityModel]?
}

struct CityModel: Codable {
    var name:String
    var children:[AreaModel]?
}

struct AreaModel: Codable {
    var name:String
    var children:[String]?
}
