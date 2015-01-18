//
//  PopulateViewController.m
//  PopSugar_Frans_Kurniawan
//
//  Created by Frans Raharja Kurniawan on 1/16/15.
//  Copyright (c) 2015 Frans Kurniawan. All rights reserved.
//

#import "PopulateViewController.h"
#import "AppDelegate.h"
#import "Non_Member.h"

#define SCROLL_VIEW_HEIGHT 200

@interface PopulateViewController ()
{
    NSManagedObject *fetchInformation;
    UIScrollView *scrollView;
    CGRect screenSize;
    NSMutableArray *currentArray;
    int currentIndex;
    int scrollIndicator;
    int scrollCurrentIndex;
    int maxValue;
    int maxValue1;
    BOOL rotation;
    Non_Member *non_Member;
}
@end

@implementation PopulateViewController
@synthesize remainingPep,leftPep,removeAllBtn,removeOneBtn,managedObjectContext,listLeftPeople;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentIndex = 1;
    scrollCurrentIndex = 1;
    maxValue = 0;
    maxValue1 = 0;
    scrollIndicator = 0;
    rotation = NO;
    listLeftPeople.scrollEnabled = YES;
    screenSize = [[UIScreen mainScreen] bounds];
    [self.navigationController setDelegate:self];
    // Do any additional setup after loading the view from its nib.
    [self updateScrollView];
}

-(NSMutableArray *)loadPeopleData
{
    managedObjectContext = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[[NSFetchRequest alloc]init]autorelease];
    [request setEntity:[NSEntityDescription entityForName:@"Member"  inManagedObjectContext:managedObjectContext]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"remaining_member" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error]autorelease];
    
    currentArray = [[[NSMutableArray alloc]init]autorelease];
    
    for (int i = 0; i < [mutableFetchResults count]; i++) {
        fetchInformation = [mutableFetchResults objectAtIndex:i];
        
        [currentArray addObject:[fetchInformation valueForKey:@"remaining_member"]];
        
        if (maxValue == 0 && i == [mutableFetchResults count]-1) {
            maxValue = [[fetchInformation valueForKey:@"remaining_member"]intValue];
        }
        
        if (maxValue1 == 0 && i == [mutableFetchResults count]-2) {
            maxValue1 = [[fetchInformation valueForKey:@"remaining_member"]intValue];
        }
    }
    
    if (mutableFetchResults == 0) {
        NSLog(@"Error fetching updated information");
    }
    
    [sortDescriptor release];
    [sortDescriptors release];
    [error release];
    
    return currentArray;
}

- (void)updateScrollView
{
    NSMutableArray *peopleArray = [[[NSMutableArray alloc]initWithArray:[self loadPeopleData]]autorelease];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 22, screenSize.size.width, SCROLL_VIEW_HEIGHT)];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    
    int x = 0;
    for (int i = 0; i < [peopleArray count]; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, screenSize.size.width, SCROLL_VIEW_HEIGHT)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%@",[peopleArray objectAtIndex:i]];
        
        //add Image
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 22, screenSize.size.width, SCROLL_VIEW_HEIGHT)];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.tag = [[peopleArray objectAtIndex:i] integerValue];
        [imageView setImage:[UIImage imageNamed:@"people.png"]];
        [imageView addSubview:label];
        [scrollView addSubview:imageView];
    
        [imageView release];
        [label release];
        x += label.frame.size.width;
        
    }
    
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:scrollView];
    
    //Update Remaining People
    remainingPep.textAlignment = NSTextAlignmentCenter;
    remainingPep.text = [NSString stringWithFormat:@"%d", (int)[peopleArray count]];
    
    //Disable button if the Member left is 1
    if ([peopleArray count] == 1) {
        removeOneBtn.enabled = NO;
        removeAllBtn.enabled = NO;
    }
    
    //Update Left People
    NSMutableArray *leftPeopleArray = [[[NSMutableArray alloc]initWithArray:[self loadLeftPeopleData]]autorelease];
    leftPep.textAlignment = NSTextAlignmentCenter;
    leftPep.text = [NSString stringWithFormat:@"%d", (int)[leftPeopleArray count]];
    if (listLeftPeople.hidden == NO) {
        [self checkLeftPeople:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [remainingPep release];
    [leftPep release];
    [scrollView release];
    [removeOneBtn release];
    [removeAllBtn release];
    [listLeftPeople release];
    [super dealloc];
}

- (void)moveScroll
{
    CGRect currentFrame;
    NSLog(@"scrollcurrentindex%d", scrollCurrentIndex);
    currentFrame.origin.x = screenSize.size.width * (scrollCurrentIndex-scrollIndicator-1);
    currentFrame.origin.y = 0;
    currentFrame.size = scrollView.frame.size;
    
    [scrollView scrollRectToVisible:currentFrame animated:YES];
}

- (IBAction)removeOneByOne:(id)sender {
    
    for (UIView *view in [scrollView subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            if (view.tag == currentIndex) {
                [view removeFromSuperview];
                [self removePerson];
            }
        }
    }
    
    [self updateScrollView];
    
    NSMutableArray *updatedPeople = [[NSMutableArray alloc]initWithArray:[self loadPeopleData]];
    
    if ([updatedPeople count] >= 2) {
        if(currentIndex == maxValue)
        {
            scrollCurrentIndex = 2;
            scrollIndicator = 0;
            
            maxValue = [[updatedPeople lastObject]intValue];
            maxValue1 = [[updatedPeople objectAtIndex:[updatedPeople count]-2]intValue];
            rotation = YES;
            
        }
        else if (currentIndex == maxValue1)
        {
            scrollCurrentIndex= 1;
            scrollIndicator = 0;
            maxValue = [[updatedPeople lastObject]intValue];
            maxValue1 = [[updatedPeople objectAtIndex:[updatedPeople count]-2]intValue];
            
            rotation = YES;
        }
        else
        {
            scrollCurrentIndex += 2;
            scrollIndicator++;
            if (!rotation) {
                currentIndex = [[updatedPeople objectAtIndex:scrollCurrentIndex-scrollIndicator-1]intValue];
            }
        }
        
        if (rotation) {
            currentIndex = [[updatedPeople objectAtIndex:scrollCurrentIndex-1]intValue];
            rotation = NO;
        }
        
        
        [self moveScroll];
    }
    else
    {
        CGRect currentFrame;
        NSLog(@"scrollcurrentindex%d", scrollCurrentIndex);
        currentFrame.origin.x = 0;
        currentFrame.origin.y = 0;
        currentFrame.size = scrollView.frame.size;
        [scrollView scrollRectToVisible:currentFrame animated:YES];
    
    }
    
    [updatedPeople release];
    
    
}

-(void)removePerson
{
    NSFetchRequest *request = [[[NSFetchRequest alloc]init]autorelease];
    [request setEntity:[NSEntityDescription entityForName:@"Member" inManagedObjectContext:managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remaining_member == %d", currentIndex];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *matchingInfo = [managedObjectContext executeFetchRequest:request error:&error];
    int removedPersonID = 0;
    if (matchingInfo.count > 0) {
        for (NSManagedObject *obj in matchingInfo) {
            removedPersonID = [[obj valueForKey:@"remaining_member"] intValue];
            [managedObjectContext deleteObject:obj];
            [managedObjectContext save:&error];
            
        }
        [self saveLeftPeople:removedPersonID];
    }
    
    [error release];
}

-(void)saveLeftPeople:(int)peopleID
{
    non_Member = [NSEntityDescription insertNewObjectForEntityForName:@"Non_Member" inManagedObjectContext:managedObjectContext];
    
    
    NSLog(@"saved left people %d", peopleID);
    NSError *error = nil;
    [non_Member setLeft_member:[NSNumber numberWithInt:peopleID]];
    [managedObjectContext save:&error];
    
    [error release];
}

-(NSMutableArray *)loadLeftPeopleData
{
    NSFetchRequest *request = [[[NSFetchRequest alloc]init]autorelease];
    [request setEntity:[NSEntityDescription entityForName:@"Non_Member"  inManagedObjectContext:managedObjectContext]];
    
    NSError *error = nil;
    NSArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error]autorelease];
    
    currentArray = [[[NSMutableArray alloc]init]autorelease];
    
    for (int i = 0; i < [mutableFetchResults count]; i++) {
        fetchInformation = [mutableFetchResults objectAtIndex:i];
        [currentArray addObject:[fetchInformation valueForKey:@"left_member"]];
    }
    
    if (mutableFetchResults.count == 0) {
        NSLog(@"No left_member");
    }
    
    [error release];
    return currentArray;
}

- (IBAction)removeEntirePeople:(id)sender {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (removeAllBtn.enabled == YES) {
            [self removeOneByOne:nil];
            [self removeEntirePeople:nil];
        }
    });
    
}

- (IBAction)checkLeftPeople:(id)sender {
    NSMutableArray *leftPeopleList = [self loadLeftPeopleData];
    
    NSString *appendedString = [[NSString alloc]init];
    listLeftPeople.hidden = NO;
    
    if ([leftPeopleList count]  > 0) {
        

        for (int i = 0; i < [leftPeopleList count]; i++) {
            appendedString = [appendedString stringByAppendingString:[NSString stringWithFormat:@"%d ",[[leftPeopleList objectAtIndex:i]intValue]]];
        }
        listLeftPeople.text = appendedString;
    }
    else
    {
        listLeftPeople.text = @"";
    }
}

#pragma ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollViews
{
    //infite scroll
    if (scrollViews.contentOffset.x < -40)
    {
        scrollViews.contentOffset = CGPointMake(scrollViews.contentSize.width-screenSize.size.width, 0);
    }
    else if (scrollViews.contentOffset.x >= scrollViews.contentSize.width-screenSize.size.width+50)
    {
        scrollViews.contentOffset = CGPointMake(0, 0);
    }
}
@end
