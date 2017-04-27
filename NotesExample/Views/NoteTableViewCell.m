//
//  NoteTableViewCell.m
//  NotesExample
//
//  Created by Raphael Araújo on 4/6/17.
//  Copyright © 2017 araujoraphael. All rights reserved.
//

#import "NoteTableViewCell.h"
#import "NSDate+FriendlyString.h"
@implementation NoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNote:(Note *)note {
    _note = note;
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.notePreviewLabel setText:self.note.content];
    [self.dateLabel setText:[self.note.date friendlyString]];
}
@end
