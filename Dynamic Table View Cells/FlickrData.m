//
//  FlickrData.m
//  Gallery
//
//  Created by Jure Žove on 5. 10. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

#import "FlickrData.h"

@implementation FlickrData

+ (id)dataWithResponseDictionary:(NSDictionary *)response {
    FlickrData *data = [[FlickrData alloc] init];
    data.photos = [FlickrPhoto photoArrayWithResponseDictionary:response];
    data.count = [response[@"photos"][@"total"] intValue];
    return data;
}

- (void)appendPhotos:(NSArray *)photos {
    self.photos = [self.photos arrayByAddingObjectsFromArray:photos];
}

@end
