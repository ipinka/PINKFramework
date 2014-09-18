//
//  PINKBaseModel.h
//  ASK
//
//  Created by Pinka on 14-7-11.
//  Copyright (c) 2014年 yiyaowang. All rights reserved.
//

#import "MTLModel.h"

/**
 *  快速调用父类方法，并生成字典，方便添加属性映射
 *
 *  @param _CONFIG_ 映射的字典，往其中加入对应属性映射
 *
 *  @return 处理好的字典_quickDict
 */
#define PINK_Quick_Config_Properties(_CONFIG_) \
+ (NSDictionary *)JSONKeyPathsByPropertyKey \
{ \
    NSMutableDictionary *_quickDict = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]]; \
    [_quickDict addEntriesFromDictionary:_CONFIG_]; \
    return [NSDictionary dictionaryWithDictionary:_quickDict]; \
}

@interface PINKBaseModel : MTLModel<MTLJSONSerializing>

@end
