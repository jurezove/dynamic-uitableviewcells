//
//  FlickrAPI.h
//  Gallery
//
//  Created by Jure Žove on 5. 10. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

/*
 * If I'd be using more APIs, I'd create a more general API class and subclass it here. Obviously, there is no need for that now.
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FlickrAPI : NSObject

+ (NSString *)urlForSearch;
+ (NSDictionary *)paramsForSearchByTags:(NSArray *)tags andPage:(NSInteger)page;
+ (NSDictionary *)paramsForSearchByTags:(NSArray *)tags withCoordinate:(CLLocationCoordinate2D)coordinate andPage:(NSInteger)page;

@end
