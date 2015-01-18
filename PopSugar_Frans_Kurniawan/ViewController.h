//
//  ViewController.h
//  PopSugar_Frans_Kurniawan
//
//  Created by Frans Raharja Kurniawan on 1/15/15.
//  Copyright (c) 2015 Frans Kurniawan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *totalPeopleField;

- (IBAction)populateTapped:(id)sender;

//Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

