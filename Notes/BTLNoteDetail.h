//
//  BTLNoteDetail.h
//  Notes
//
//  Created by Benedikt Lotter on 3/8/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BTLNoteDetail : NSObject

@property (strong, nonatomic) NSString *noteTitle;
@property (strong, nonatomic) NSString *noteDescription;
@property (strong, nonatomic) CLLocation *notelocation;

@end
