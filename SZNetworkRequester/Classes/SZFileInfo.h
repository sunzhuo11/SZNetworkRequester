//
//  SZFileInfo.h
//  SZNetWorkRequester
//
//  Created by Stella on 16/3/23.
//  Copyright © 2016年 sunzhuo11. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZFileInfo : NSObject

@property (nonatomic,strong) NSData *content;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSString *mimeType;

@end
