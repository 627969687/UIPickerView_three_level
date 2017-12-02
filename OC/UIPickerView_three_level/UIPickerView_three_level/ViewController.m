//
//  ViewController.m
//  UIPickerView_three_level
//
//  Created by 荣 Jason on 2017/11/29.
//  Copyright © 2017年 荣 Jason. All rights reserved.
//

#import "ViewController.h"

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager+JSManager.h"

#import <MJExtension/MJExtension.h>
#import "ProvinceModel.h"
#import "CityModel.h"
#import "AreaModel.h"

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property(nonatomic,strong)NSArray<ProvinceModel *> *provinceArr; // 省
@property(nonatomic,strong)NSArray<CityModel *> *cityArr; // 市
@property(nonatomic,strong)NSArray<AreaModel *> *areaArr; // 区
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [self loadData];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self loadData];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self loadData];
                break;
                
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)loadData {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager js_mgr];
    // 参考假数据实现《http://192.168.11.128/getArea.html》
    [mgr GET:@"http://192.168.11.128/getArea.html" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *result) {
        // 省
        self.provinceArr = [ProvinceModel mj_objectArrayWithKeyValuesArray:result[@"resultInfo"]];
        // 市
        self.cityArr = self.provinceArr.firstObject.children;
        // 区
        self.areaArr = self.cityArr.firstObject.children;
        [self.pickerView reloadAllComponents];
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    }];
}

#pragma mark - <UIPickerView代理、数据源>
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// 每列有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger ret = 0;
    switch (component) {
        case 0: // 省
            ret = self.provinceArr.count;
            break;
        case 1: // 市
            ret = self.cityArr.count;
            break;
        case 2: // 区
            ret = self.areaArr.count;
            break;
    }
    return ret;
}

// 返回每一行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *ret = @"";
    switch (component) {
        case 0:
            ret = self.provinceArr[row].name;
            break;
        case 1:
            ret = self.cityArr[row].name;
            break;
        case 2:
            ret = self.areaArr[row].name;
            break;
    }
    return ret;
}

// 滑动或点击选择，确认pickerView选中结果

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: // 省
            self.cityArr = self.provinceArr[row].children;
            self.areaArr = self.cityArr.firstObject.children;
            
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:1 animated:false];
            [self.pickerView selectRow:0 inComponent:2 animated:false];
            break;
        case 1: // 市
            self.areaArr = self.cityArr[row].children;
            
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:2 animated:false];
            break;
        case 2: // 区
            break;
    }
}

@end
