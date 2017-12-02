//
//  AFHTTPSessionManager+JSManager.m
//  PickerTest
//
//  Created by 荣 Jason on 2017/11/29.
//  Copyright © 2017年 荣 Jason. All rights reserved.
//

#import "AFHTTPSessionManager+JSManager.h"

@implementation AFHTTPSessionManager (JSManager)
+ (instancetype)js_mgr {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    response.removesKeysWithNullValues = YES;//去除空值
    mgr.responseSerializer = response;
    return mgr;
}
@end
