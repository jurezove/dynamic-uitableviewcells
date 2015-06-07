//
//  Photo.m
//  Gallery
//
//  Created by Jure Žove on 5. 10. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (NSString *)url {
    NSAssert(NO, @"This method should be overriden.");
    return nil;
}

- (NSString *)title {
    NSAssert(NO, @"This method should be overriden.");
    return nil;
}

@end
