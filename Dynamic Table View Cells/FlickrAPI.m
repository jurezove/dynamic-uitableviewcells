//
//  FlickrAPI.m
//  Gallery
//
//  Created by Jure Žove on 5. 10. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

#import "FlickrAPI.h"

static NSString *const FlickrAPIEndpoint =      @"https://api.flickr.com/services";
static NSString *const FlickrAPIKey =           @"5bef90c42d5be4a6307b56bbb7d650e6";

@implementation FlickrAPI

+ (NSString *)urlForSearch {
    return [NSString stringWithFormat:@"%@/rest/", FlickrAPIEndpoint];
}

+ (NSDictionary *)paramsForSearchByTags:(NSArray *)tags andPage:(NSInteger)page {
    NSString *encodedTags = [[tags componentsJoinedByString:@","] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return @{@"api_key" : FlickrAPIKey, @"method" : @"flickr.photos.search", @"tags" : encodedTags, @"format" : @"json", @"nojsoncallback" : @"1", @"page" : @(page) };
}

+ (NSDictionary *)paramsForSearchByTags:(NSArray *)tags withCoordinate:(CLLocationCoordinate2D)coordinate andPage:(NSInteger)page {
    NSDictionary *dict = [[self paramsForSearchByTags:tags andPage:page] mutableCopy];
    [dict setValuesForKeysWithDictionary:@{ @"lat" : @(coordinate.latitude), @"lon" : @(coordinate.longitude) }];
    return dict;
}

@end
