//
//  ViewController.swift
//  UIPickerView_three_level
//
//  Created by kuyou1 on 2018/2/5.
//  Copyright © 2018年 kuyou. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    
    var model:Model!
    var provinceArr:[ProvinceModel]!
    var cityArr:[CityModel]!
    var areaArr:[AreaModel]!
    var networkMgr:NetworkReachabilityManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        networkMgr = NetworkReachabilityManager()
        networkMgr.listener = { status in
            switch status {
            case .unknown:
                print("###未知网络")
                self.loadData()
                break
            case .reachable(.ethernetOrWiFi):
                print("###wifi")
                self.loadData()
                break
            case .reachable(.wwan):
                print("###移动数据")
                self.loadData()
                break
            case .notReachable:
                print("###没有网络")
                break
            }
        }
        networkMgr.startListening()
    }
}

// MARK: - 数据加载
extension ViewController {
    func loadData() {
        request("http://172.16.19.97/getArea.html").responseJSON { (response) in
            self.model = try? JSONDecoder().decode(Model.self, from: response.data!)
            self.provinceArr = self.model.resultInfo
            self.cityArr = self.provinceArr.first?.children
            self.areaArr = self.cityArr.first?.children
            self.pickerView.reloadAllComponents()
        }
    }
}

// MARK: - UIPickerViewDelegate,UIPickerViewDataSource
extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var ret = 0
        switch component {
        case 0:
            ret = ((self.provinceArr == nil) ? 0 : self.provinceArr.count)
            break
        case 1:
            ret = ((self.cityArr == nil) ? 0 : self.cityArr.count)
            break
        case 2:
            ret = ((self.areaArr == nil) ? 0 : self.areaArr.count)
            break
        default:
            break
        }
        return ret
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var ret = ""
        switch component {
        case 0:
            ret = ((self.provinceArr == nil) ? "" : self.provinceArr[row].name)
            break
        case 1:
            ret = ((self.cityArr == nil) ? "" : self.cityArr[row].name)
            break
        case 2:
            ret = ((self.areaArr == nil) ? "" : self.areaArr[row].name)
            break
        default:
            break
        }
        return ret
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.cityArr = self.provinceArr[row].children
            self.areaArr = self.cityArr.first?.children
            self.pickerView.selectRow(0, inComponent: 1, animated: false)
            self.pickerView.selectRow(0, inComponent: 2, animated: false)
            self.pickerView.reloadAllComponents()
            break
        case 1:
            self.areaArr = self.cityArr[row].children
            self.pickerView.selectRow(0, inComponent: 2, animated: false)
            self.pickerView.reloadComponent(2)
            break
        case 2:
            break
        default:
            break
        }
    }
}

