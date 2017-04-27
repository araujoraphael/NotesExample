//
//  WebManager.h
//  NotesExample
//
//  Created by Raphael Araújo on 4/3/17.
//  Copyright © 2017 araujoraphael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebManager : NSObject
@property (nonatomic, strong) NSString *token;
typedef void(^DataWebCallback)(BOOL error, NSString *message, NSData *data);
+ (instancetype)sharedManager;
-(void)notesRequest:(DataWebCallback)callback;
-(void)loginRequest:(NSString *)username encryptedPassword:(NSString *)encryptedPassword callback:(DataWebCallback)callback;
-(void)createNoteRequest:(NSString *)text datetime:(NSString *)datetime callback:(DataWebCallback)callback;
-(void)updateNoteRequest:(NSString *)text noteId:(NSInteger)noteId callback:(DataWebCallback)callback;
- (void)deleteNoteRequest:(NSInteger )noteId callback:(DataWebCallback)callback;
@end
