//
//  NewEmpireController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewEmpireController.h"
#import "LEViewSectionTab.h"
#import "LEMacros.h"
#import "LEEmpireCreate.h"
#import "LEEmpireFound.h"
#import "LESpeciesSetHuman.h"
#import "Session.h"
#import "NewSpeciesController.h"


@interface NewEmpireController (PrivateMethods)

- (void)handleSpeciesSelection;

@end


@implementation NewEmpireController


//@synthesize activityIndicator;
@synthesize nameCell;
@synthesize passwordCell;
@synthesize passwordConfirmationCell;
@synthesize speciesCell;
@synthesize speciesSelector;
@synthesize empireId;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"New Empire";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];
	self.hidesBottomBarWhenPushed = YES;
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Empire"]);
	
	self.nameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.nameCell.label.text = @"Name";
	self.nameCell.delegate = self;
	
	self.passwordCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.passwordCell.label.text = @"Password";
	self.passwordCell.delegate = self;
	self.passwordCell.secureTextEntry = YES;
	
	self.passwordConfirmationCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.passwordConfirmationCell.label.text = @"Confirm";
	self.passwordConfirmationCell.delegate = self;
	self.passwordConfirmationCell.secureTextEntry = YES;
	
	self.speciesCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	self.speciesCell.selectionStyle = UITableViewCellSelectionStyleNone;
	self.speciesCell.backgroundColor = CELL_BACKGROUND_COLOR;
	self.speciesSelector = [[[UISegmentedControl alloc] initWithItems:_array(@"Human", @"Custom")] autorelease];
	[self.speciesSelector addTarget:self action:@selector(speciesSelected) forControlEvents:UIControlEventValueChanged];
	self.speciesSelector.tintColor = TINT_COLOR;
	self.speciesSelector.segmentedControlStyle = UISegmentedControlStyleBar;
	self.speciesSelector.center = self.speciesCell.center;
	self.speciesSelector.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[self.speciesCell.contentView addSubview:self.speciesSelector];
	
#if TARGET_IPHONE_SIMULATOR
	self.nameCell.textField.text = @"bob";
	self.passwordCell.textField.text = @"abc123";
	self.passwordConfirmationCell.textField.text = @"abc123";
#else
	self.nameCell.textField.text = @"";
	self.passwordCell.textField.text = @"";
	self.passwordConfirmationCell.textField.text = @"";
#endif
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
	
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
				cell = self.nameCell;
				break;
			case 1:
				cell = self.passwordCell;
				break;
			case 2:
				cell = self.passwordConfirmationCell;
				break;
			case 3:
				cell = self.speciesCell;
				break;
			default:
				cell = nil;
				break;
		}
	} else {
		cell = nil;
    }
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.nameCell = nil;
	self.passwordCell = nil;
	self.passwordConfirmationCell = nil;
	self.speciesCell = nil;
	self.speciesSelector = nil;
	[self viewDidUnload];
}


- (void)dealloc {
	self.empireId = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == nameCell.textField) {
		[nameCell resignFirstResponder];
		[passwordCell becomeFirstResponder];
	} else if (textField == passwordCell.textField) {
		[passwordCell resignFirstResponder];
		[passwordConfirmationCell becomeFirstResponder];
	} else if (textField == passwordConfirmationCell.textField) {
		[passwordConfirmationCell resignFirstResponder];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Callbacks


- (IBAction)speciesSelected {
	if (self.speciesSelector.selectedSegmentIndex != UISegmentedControlNoSegment) {
		if (self.empireId) {
			NSLog(@"has empireId");
			[self handleSpeciesSelection];
		} else{
			NSLog(@"creating empire");
			[[[LEEmpireCreate alloc] initWithCallback:@selector(empireCreated:) target:self name:self.nameCell.textField.text password:self.passwordCell.textField.text password1:self.passwordConfirmationCell.textField.text] autorelease];
		}
	}
}


- (void)cancel {
	[self dismissModalViewControllerAnimated:YES];
}


- (id) empireCreated:(LEEmpireCreate *) request {
	if ([request wasError]) {
		switch ([request errorCode]) {
			case 1000:
				; //DO NOT REMOVE
				[request markErrorHandled];
				UIAlertView *nameAlertView = [[[UIAlertView alloc] initWithTitle:@"Could not create empire" message:@"Empire name invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[nameAlertView show];
				break;
			case 1001:
				; //DO NOT REMOVE
				[request markErrorHandled];
				UIAlertView *passwordAlertView = [[[UIAlertView alloc] initWithTitle:@"Could not create empire" message:@"Password invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[passwordAlertView show];
				break;
		}
		self.speciesSelector.selectedSegmentIndex = UISegmentedControlNoSegment;
	} else {
		self.empireId = request.empireId;
		self.nameCell.textField.enabled = NO;
		self.passwordCell.textField.enabled = NO;
		self.passwordConfirmationCell.textField.enabled = NO;
		[self handleSpeciesSelection];
	}
	
	return nil;
}


- (id)humanSet:(LESpeciesSetHuman *) request {
	NSLog(@"Human set");
	if ([request wasError]) {
		NSLog(@"%@", [request errorMessage]);
	} else {
		NSLog(@"Founding Empire: %@", self.empireId);
		[[[LEEmpireFound alloc] initWithCallback:@selector(empireFounded:) target:self empireId:self.empireId] autorelease];
	}
	
	return nil;
}


- (id)empireFounded:(LEEmpireFound *) request {
	NSLog(@"Empire Founded");
	if ([request wasError]) {
		//WHAT TO DO?
	} else {
		[self dismissModalViewControllerAnimated:YES];
		Session *session = [Session sharedInstance];
		[session loginWithUsername:self.nameCell.textField.text password:self.passwordCell.textField.text];
		
	}
	
	return nil;
}


#pragma mark -
#pragma mark PrivateMethods


- (void)handleSpeciesSelection {
	switch (self.speciesSelector.selectedSegmentIndex) {
		case 0:
			//[[[LESpeciesSetHuman alloc] initWithCallback:@selector(humanSet:) target:self empireId:self.empireId] autorelease];
			[[[LEEmpireFound alloc] initWithCallback:@selector(empireFounded:) target:self empireId:self.empireId] autorelease];
			break;
		case 1:
			; //Do Not Remove
			NewSpeciesController *newSpeciesController = [NewSpeciesController create];
			newSpeciesController.empireId = self.empireId;
			newSpeciesController.username = self.nameCell.textField.text;
			newSpeciesController.password = self.passwordCell.textField.text;
			[[self navigationController] pushViewController:newSpeciesController animated:YES];
			break;
	}
	self.speciesSelector.selectedSegmentIndex = UISegmentedControlNoSegment;
}


#pragma mark -
#pragma mark Class Methods

+ (NewEmpireController *) create {
	return [[[NewEmpireController alloc] init] autorelease];
}


@end

