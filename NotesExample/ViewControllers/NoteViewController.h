//
//  NoteViewController.h
//  NotesExample
//
//  Created by Raphael Araújo on 4/6/17.
//  Copyright © 2017 araujoraphael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
@protocol NoteViewControllerDelegate;
@protocol NoteViewControllerDelegate <NSObject>
@optional
- (void)didCreateNote:(Note *)note;
- (void)didDeleteNote:(Note *)note;

@end
@interface NoteViewController : UIViewController
@property (nonatomic, strong) Note *note;
@property (nonatomic, strong) id<NoteViewControllerDelegate> delegate;
@end
