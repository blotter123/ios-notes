//
//  BTLNoteViewController.h
//  Notes
//
//  Created by Benedikt Lotter on 3/8/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BTLNoteDetail.h"
#import "BTLTableViewController.h"
#import "BTLLocationManager.h"



@protocol NoteSelectorDelegate <NSObject>

@optional

- (void)updateNote:(NSString*)descriptionString withTitle:(NSString *)titleString atIndex:(NSInteger *)index;

@end



@interface BTLNoteViewController : UIViewController <LocationControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) BTLNoteDetail *currentNote;
@property NSInteger *currentNoteIndex;
@property (nonatomic, weak) id <NoteSelectorDelegate> delegate;


@property (weak, nonatomic) IBOutlet MKMapView *mapView;


-(void)setFields;


@end




