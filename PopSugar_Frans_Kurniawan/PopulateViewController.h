//
//  PopulateViewController.h
//  PopSugar_Frans_Kurniawan
//
//  Created by Frans Raharja Kurniawan on 1/16/15.
//  Copyright (c) 2015 Frans Kurniawan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopulateViewController : UIViewController<UINavigationControllerDelegate,UIScrollViewDelegate>

//@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, atomic) IBOutlet UILabel *remainingPep;
@property (retain, atomic) IBOutlet UILabel *leftPep;
@property (retain, atomic) IBOutlet UIButton *removeOneBtn;
@property (retain, atomic) IBOutlet UIButton *removeAllBtn;
@property (retain, nonatomic) IBOutlet UITextView *listLeftPeople;

- (IBAction)removeOneByOne:(id)sender;
- (IBAction)removeEntirePeople:(id)sender;
- (IBAction)checkLeftPeople:(id)sender;

//Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
