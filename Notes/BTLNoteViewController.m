//
//  BTLNoteViewController.m
//  Notes
//
//  Created by Benedikt Lotter on 3/8/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import "BTLNoteViewController.h"
#import "BTLAppDelegate.h"
#import "BTLLocationSelectController.h"

@interface BTLNoteViewController ()

@end

@implementation BTLNoteViewController


- (void) setFields
{
    self.titleTextField.text = _currentNote.noteTitle;
    self.descriptionTextView.text = _currentNote.noteDescription;
    //[self addPinToMapAtLocation:_currentNote.notelocation];
    self.descriptionTextView.delegate = self;
}



//in viewDidLoad, set the fields of the noteView to the values corresponding to _currentNote
- (void)viewDidLoad
{
    self.titleTextField.text = _currentNote.noteTitle;
    self.descriptionTextView.text = _currentNote.noteDescription;
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [BTLLocationManager sharedLocationManager].delegate = self;
    
    //in case, no location has been set for the note, set it here
    if (!(_currentNote.notelocation)) {
        CLLocation *currentLocation = [BTLLocationManager sharedLocationManager].locationManager.location;
        _currentNote.notelocation = currentLocation;
    }
    [self addPinToMapAtLocation:_currentNote.notelocation];
    self.descriptionTextView.delegate = self;
}


//IBAction to change title property of  _currentNote if corresponding textField is changed
- (IBAction)changeTitle:(id)sender {
    
    _currentNote.noteTitle = self.titleTextField.text;
    [self.delegate updateNote:self.descriptionTextView.text withTitle:self.titleTextField.text atIndex:self.currentNoteIndex];
}

//IBAction to change description property of  _currentNote if corresponding textView is changed
-(void)textViewDidChange:(UITextView *)textView {
    _currentNote.noteDescription = self.descriptionTextView.text;
    [self.delegate updateNote:self.descriptionTextView.text withTitle:self.titleTextField.text atIndex:self.currentNoteIndex];
    
}


#pragma mark - LocationControllerDelegate methods

//delegate method that gets called by the singelton class BTLCLLocationManagerDelegate once a location update is detected
- (void)locationUpdate:(CLLocation *)location
{
    
}


// method to draw pins to the map based on the location passed down from the shared location manager
- (void)addPinToMapAtLocation:(CLLocation *)location
{
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = location.coordinate;
    pin.title = _currentNote.noteTitle;
    pin.subtitle = _currentNote.noteDescription;
    [self.mapView addAnnotation:pin];
    MKCoordinateRegion region = { { 0.0f, 0.0f }, { 0.0f, 0.0f } };
    region.center = location.coordinate;
    region.span.longitudeDelta = 0.15f;
    region.span.latitudeDelta = 0.15f;
    [self.mapView setRegion:region animated:YES];
}


// preparation for segue from tableView to noteView
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LocationSelect"]) {
        BTLLocationManager *locationSelector = [segue destinationViewController];
        locationSelector.delegate = self;
    }
}


#pragma mark locationSelectorDelegate

-(void) setLocation:(CLLocation*)location
{
    _currentNote.notelocation = location;
    NSLog(@"location chosen = %f %f",location.coordinate.latitude,location.coordinate.longitude);
    
    //remove previous pins and add pin at updated location
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self addPinToMapAtLocation:_currentNote.notelocation];
}


@end
