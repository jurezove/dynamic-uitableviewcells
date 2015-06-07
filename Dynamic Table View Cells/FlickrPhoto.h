//
//  FlickrPhoto.h
//  Gallery
//
//  Created by Jure Žove on 5. 10. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface FlickrPhoto : Photo

/*
 *  For demo purposes, I'll implement only the necessary attributes.
 */

@property (nonatomic, strong) NSString *photoID;
@property (nonatomic, strong) NSString *farm;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *title;

+ (id)photoWithResponseDictionary:(NSDictionary *)dict;
+ (NSArray *)photoArrayWithResponseDictionary:(NSDictionary *)dict;

@end
