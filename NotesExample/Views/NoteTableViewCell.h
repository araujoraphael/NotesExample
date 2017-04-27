//
//  NoteTableViewCell.h
//  NotesExample
//
//  Created by Raphael Araújo on 4/6/17.
//  Copyright © 2017 araujoraphael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
@interface NoteTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *notePreviewLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) Note *note;
@end
