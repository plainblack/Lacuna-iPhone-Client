//
//  EditSavedEmpire.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditSavedEmpire : UIViewController {
	UITextField *username;
	UITextField *password;
	UITextField *server;
	NSString *empireName;
}


@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UITextField *server;
@property (nonatomic, retain) NSString *empireName;


- (IBAction)cancel;
- (IBAction)save;
- (IBAction)login;


@end
