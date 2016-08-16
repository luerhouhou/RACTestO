//
//  EFSLogger.m
//  EFSMobile
//
//  Created by zhanglu on 16/7/1.
//  Copyright © 2016年 Elephants Financial Service. All rights reserved.
//

#import "EFSLogger.h"

@interface EFSLogger ()

@property (nonatomic, copy) NSString * urlString;
@property (nonatomic, copy) NSString * socketCode;
@property (nonatomic, copy) NSDictionary * params;
@property (nonatomic, copy) NSError * error;

@end

@implementation EFSLogger

- (instancetype)initWithURLString:(NSString *)urlString params:(NSDictionary *)params error:(NSError *)error
{
    self = [super init];
    if (self == nil) return nil;
    
    if ([urlString integerValue] > 0) {
        _socketCode = urlString;
    } else {
        _urlString = urlString;
    }
    _params = params;
    self.error = error;
    return self;
}

- (void)setError:(NSError *)error
{
    _error = error;
    if (!error) return;
    if (_socketCode) {
        NSLog(@"socketCode:%@\n%@\n%@",_socketCode, _params, _error);
    } else {
        NSLog(@"requestUrl%@\n%@\n%@",_urlString, _params, _error);
    }
}

@end
