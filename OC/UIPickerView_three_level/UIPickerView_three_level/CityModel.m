//
//  CityModel.m
//  UIPickerView_three_level
//
//  Created by 荣 Jason on 2017/12/1.
//  Copyright © 2017年 荣 Jason. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"children" : @"AreaModel",};
}

@end
