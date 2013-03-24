//
//  BTLTableViewController.m
//  Notes
//
//  Created by Benedikt Lotter on 3/7/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import "BTLTableViewController.h"
#import "BTLNoteViewController.h"
#import "Note.h"


#define kBTLCellIdentifier @"My Cell"

@interface BTLTableViewController ()
@property (nonatomic) BOOL beganUpdates;
@end

@implementation BTLTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize suspendAutomaticTrackingOfChangesInManagedObjectContext = _suspendAutomaticTrackingOfChangesInManagedObjectContext;
@synthesize debug = _debug;
@synthesize beganUpdates = _beganUpdates;


#pragma mark - Fetching methods for NSFetchedResultsControllers

- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate) {
            if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
        } else {
            if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
        }
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.tableView reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            if (self.debug) NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            [self performFetch];
        } else {
            if (self.debug) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.tableView reloadData];
        }
    }
}













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
    
    _dataManager = [[BTLDataManagers alloc]init];
    
    
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
    
     return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    
    //return [self.notes count];  //original non-persistent method
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



#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        [self.tableView beginUpdates];
        self.beganUpdates = YES;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) [self.tableView endUpdates];
}

- (void)endSuspensionOfUpdatesDueToContextChanges
{
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}




- (IBAction)newNote:(id)sender {
    
    
    // Create and configure a new instance of the Note entity.
   //[_dataManager addNote];
    
    
    //orgiginal non-persistent creation
    
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
    
    //original non-persistent update
    int changedIndex = index;
    BTLNoteDetail *changedNote = _notes[changedIndex];
    changedNote.noteTitle = titleString;
    changedNote.noteDescription = descriptionString;
    _notes[changedIndex] = changedNote;
    [self.tableView reloadData];

    
    
    [_dataManager updateNote:changedNote withTitle:titleString description:descriptionString latitude:changedNote.notelocation.coordinate.latitude longitude:changedNote.notelocation.coordinate.longitude];
    
    
        
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
