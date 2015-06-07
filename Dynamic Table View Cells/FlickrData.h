//
//  FlickrData.h
//  Gallery
//
//  Created by Jure Žove on 5. 10. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrPhoto.h"

@interface FlickrData : NSObject

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic) NSInteger count;

+ (id)dataWithResponseDictionary:(NSDictionary *)response;
- (void)appendPhotos:(NSArray *)photos;

@end
