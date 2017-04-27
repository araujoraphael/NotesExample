//
//  NSDate+FriendlyString.m
//  NotesExample
//
//  Created by Raphael Araújo on 4/6/17.
//  Copyright © 2017 araujoraphael. All rights reserved.
//

#import "NSDate+FriendlyString.h"

@implementation NSDate (FriendlyString)
- (NSString *)friendlyString {
    NSString *friendlyString = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    friendlyString = [dateFormatter stringFromDate:self];
    return friendlyString;
}
@end
