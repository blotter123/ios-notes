//
//  BTLTableViewController.m
//  Notes
//
//  Created by Benedikt Lotter on 3/7/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import "BTLTableViewController.h"
#import "BTLNoteViewController.h"


#define kBTLCellIdentifier @"My Cell"

@interface BTLTableViewController ()

@end

@implementation BTLTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    _notes = [[NSMutableArray alloc]init];
    
    /*create test notes
    BTLNoteDetail *testNote1 = [[BTLNoteDetail alloc]init];
    testNote1.noteTitle = @"test title1";
    testNote1.noteDescription = @"test description1";
    
    BTLNoteDetail *testNote2 = [[BTLNoteDetail alloc]init];
    testNote2.noteTitle = @"test title2";
    testNote2.noteDescription = @"test description2";
    
    [_notes addObject:testNote1];
    [_notes addObject:testNote2];
     
     */
    
    [self.tableView reloadData];
}

-(void)setNotes:(NSMutableArray *)notes
{
    _notes = notes;
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBTLCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self getTitleForRow:indexPath.row];
    return cell;
}

- (NSString *)getTitleForRow:(NSInteger)row
{
    
    int selectedRow = row;
    BTLNoteDetail *selectedNote = _notes[selectedRow];
    NSString *title = selectedNote.noteTitle;
    return title;

    //return @"test";
}

// preparation for segue from tableView to noteView
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue called");
    if ([[segue identifier] isEqualToString:@"ShowDetails"]) {
        BTLNoteViewController *noteViewController = [segue destinationViewController];
        //alternatively:NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        noteViewController.currentNote = _notes[indexPath.row];
        noteViewController.currentNoteIndex = (NSInteger*) indexPath.row;
        //[noteViewController setFields];
        noteViewController.delegate = self;
        }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //int deleteRow = indexPath.row;
        // = nil;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/



- (IBAction)newNote:(id)sender {
    
    BTLNoteDetail *addNote = [[BTLNoteDetail alloc]init];
    //NSLog(@"%b", [BTLLocationManager sharedLocationManager].locationManager.location);
    CLLocation *currentLocation = [BTLLocationManager sharedLocationManager].locationManager.location;
    NSLog(@"when new lat: %f,  when new lon:%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    addNote.noteTitle = @"New Title here";
    addNote.noteDescription = @"New Description here";
    addNote.notelocation = currentLocation;
    [_notes addObject:addNote];
    [self.tableView reloadData];
}





#pragma mark - noteSelector delegate

//method called when segue from noteViewController to tableViewController to pass updated information back.

- (void)updateNote:(NSString*)descriptionString withTitle:(NSString *)titleString atIndex:(NSInteger)index
{
    int changedIndex = index;
    BTLNoteDetail *changedNote = _notes[changedIndex];
    changedNote.noteTitle = titleString;
    changedNote.noteDescription = descriptionString;
    _notes[changedIndex] = changedNote;
    [self.tableView reloadData];
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     //BTLNoteViewController *noteDetailViewController = [[BTLNoteViewController alloc] init];
     // ...
     // Pass the selected object to the new view controller.
     //[self.navigationController pushViewController:noteDetailViewController animated:YES];
     
}

@end
