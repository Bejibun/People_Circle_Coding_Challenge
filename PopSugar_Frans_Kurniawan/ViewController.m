//
//  ViewController.m
//  PopSugar_Frans_Kurniawan
//
//  Created by Frans Raharja Kurniawan on 1/15/15.
//  Copyright (c) 2015 Frans Kurniawan. All rights reserved.
//

#import "ViewController.h"
#import "PopulateViewController.h"
#import "AppDelegate.h"
#import "Member.h"

@interface ViewController ()
{
    Member *members;
}
@end

@implementation ViewController
@synthesize totalPeopleField,managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [totalPeopleField release];
    [super dealloc];
}

- (IBAction)populateTapped:(id)sender
{
    if ([totalPeopleField.text integerValue] < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid input" message:@"Minimum value is 1" delegate:self cancelButtonTitle:@"Fix" otherButtonTitles: nil];
        [alert show];
        [alert release];
        totalPeopleField.text = @"1";
    }
    else
    {
        [self addPeopleData];
        PopulateViewController *populateVC = [[PopulateViewController alloc]initWithNibName:@"PopulateViewController" bundle:nil];
        
        [self.navigationController pushViewController:populateVC animated:YES];
        [populateVC release];
    }
}

-(void)addPeopleData
{
    managedObjectContext = [appDelegate managedObjectContext];
    [self removeAllContentCoreData];
    
    NSError *error = nil;
    
    for (int i = 1; i < [totalPeopleField.text integerValue]+1; i++) {
        members = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:managedObjectContext];
        
        [members setRemaining_member:[NSNumber numberWithInt:i]];
        [managedObjectContext save:&error];
    }
    
    if (!error) {
        NSLog(@"Saved!");
    }
    
    [error release];

}

-(void)removeAllContentCoreData
{
    NSFetchRequest *request = [[[NSFetchRequest alloc]init]autorelease];
    NSFetchRequest *requestNonMember = [[[NSFetchRequest alloc]init]autorelease];
    
    [request setEntity:[NSEntityDescription entityForName:@"Member" inManagedObjectContext:managedObjectContext]];
    
    [requestNonMember setEntity:[NSEntityDescription entityForName:@"Non_Member" inManagedObjectContext:managedObjectContext]];
    
    NSError *error = nil;
    
    
    //Remove Member
    NSArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error]retain];
    
    if (mutableFetchResults.count > 0) {
        for (NSManagedObject *obj in mutableFetchResults) {
            [managedObjectContext deleteObject:obj];
        }
    }
    [mutableFetchResults release];
    
    //Remove Non_Member
    mutableFetchResults = [[managedObjectContext executeFetchRequest:requestNonMember error:&error]retain];
    
    if (mutableFetchResults.count > 0) {
        for (NSManagedObject *obj in mutableFetchResults) {
            [managedObjectContext deleteObject:obj];
        }
    }
    
    //[request release];
    //[requestNonMember release];
    [error release];
    [mutableFetchResults release];
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        UIToolbar *toolBar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        
        UIBarButtonItem *doItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked)];
        [toolBar1 setItems:@[doItem]]; textField.inputAccessoryView = toolBar1;
        
        [toolBar1 release];
        [doItem release];
    }
}

-(void)doneButtonClicked
{
    for (UITextField *txtfld in self.view.subviews)
    {
        [txtfld resignFirstResponder];
    }
}
@end
