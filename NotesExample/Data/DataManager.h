//
//  DataManager.h
//  NotesExample
//
//  Created by Raphael Araújo on 4/3/17.
//  Copyright © 2017 araujoraphael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
typedef void(^ArrayDataCallback)(BOOL error, NSString *message, NSArray *array);
typedef void(^DataCallback)(BOOL error, NSData *data);
typedef void(^StringCallback)(BOOL error, NSString *message, NSString *token);

+ (instancetype)sharedManager;
-(void)getNotesList:(ArrayDataCallback)callback;
-(void)login:(NSString *)username password:(NSString *)password callback:(StringCallback)callback;
- (void)createNote:(NSString *)text datetime:(NSString *)datetime callback:(StringCallback)callback;
- (void)updateNote:(NSString *)text noteId:(NSInteger)noteId callback:(StringCallback)callback;
- (void)deleteNote:(NSInteger )noteId callback:(StringCallback)callback;

@end
