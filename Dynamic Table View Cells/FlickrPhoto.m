//
//  FlickrPhoto.m
//  Gallery
//
//  Created by Jure Žove on 5. 10. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

#import "FlickrPhoto.h"

@implementation FlickrPhoto

static NSString *kSizeSuffix = @"z";

+ (id)photoWithResponseDictionary:(NSDictionary *)dict {
    FlickrPhoto *photo = [[FlickrPhoto alloc] init];
    photo.photoID = dict[@"id"];
    photo.title = dict[@"title"];
    photo.secret = dict[@"secret"];
    photo.farm = dict[@"farm"];
    photo.server = dict[@"server"];
    return photo;
}

+ (NSArray *)photoArrayWithResponseDictionary:(NSDictionary *)dict {
    NSArray *photos = dict[@"photos"][@"photo"];
    NSMutableArray *convertedPhotos = [NSMutableArray arrayWithCapacity:photos.count];
    for (NSDictionary *photoDict in photos) {
        [convertedPhotos addObject:[self photoWithResponseDictionary:photoDict]];
    }
    return [NSArray arrayWithArray:convertedPhotos];
}

- (NSString *)url {
    return [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", self.farm, self.server, self.photoID, self.secret, kSizeSuffix];
}

@end
