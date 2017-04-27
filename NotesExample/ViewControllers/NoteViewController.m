//
//  NoteViewController.m
//  NotesExample
//
//  Created by Raphael Araújo on 4/6/17.
//  Copyright © 2017 araujoraphael. All rights reserved.
//

#import "NoteViewController.h"
#import "DataManager.h"
#import "NSDate+FriendlyString.h"
@interface NoteViewController ()
@property (nonatomic, weak) IBOutlet UITextView *textView;
@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteTapped:)];
    if(self.note) {
        [self.textView setText:self.note.content];
    } else {
        self.note = [[Note alloc] init];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.note.content = self.textView.text;
    if(self.note.noteId == -1) {
        [self.delegate didCreateNote:self.note];
        [[DataManager sharedManager] createNote:self.note.content datetime:[[NSDate date] friendlyString] callback:^(BOOL error, NSString *message, NSString *token) {
        }];
    } else {
        [[DataManager sharedManager] updateNote:self.note.content noteId:self.note.noteId callback:^(BOOL error, NSString *message, NSString *token) {
        }];
    }
}
- (void)deleteTapped:(id) sender {
    if(self.note.noteId != -1) {
        [[DataManager sharedManager] deleteNote:self.note.noteId callback:^(BOOL error, NSString *message, NSString *token) {
            if(!error) {
                [self.delegate didDeleteNote:self.note];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
            }
        }];
    } else {
        [self.delegate didDeleteNote:self.note];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
