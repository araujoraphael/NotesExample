//
//  Note.h
//  NotesExample
//
//  Created by Raphael Araújo on 4/3/17.
//  Copyright © 2017 araujoraphael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *date;
@property NSInteger noteId;
@end
