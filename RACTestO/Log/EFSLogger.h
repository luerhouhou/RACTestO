//
//  EFSLogger.h
//  EFSMobile
//
//  Created by zhanglu on 16/7/1.
//  Copyright © 2016年 Elephants Financial Service. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"%s|%d|] //[ERROR]\n" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

#define EFSLog(URLSTRING, PARAMS, ERROR) \
[[EFSLogger alloc] initWithURLString:URLSTRING params:PARAMS error:ERROR];

@interface EFSLogger : NSObject

@property (nonatomic, copy, readonly) NSString * urlString;
@property (nonatomic, copy, readonly) NSString * scoketCode;
@property (nonatomic, copy, readonly) NSDictionary * params;
@property (nonatomic, copy, readonly) NSError * error;

- (instancetype)initWithURLString:(NSString *)urlString params:(NSDictionary *)params error:(NSError *)error;

@end
