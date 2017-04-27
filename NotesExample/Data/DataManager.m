//
//  DataManager.m
//  NotesExample
//
//  Created by Raphael Araújo on 4/3/17.
//  Copyright © 2017 araujoraphael. All rights reserved.
//

#import "DataManager.h"
#import "WebManager.h"
#import "NSString+MD5.h"
#import "Note.h"
@implementation DataManager
+ (instancetype)sharedManager
{
    static DataManager *_sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedManager = [[self alloc] initSingleton];
    });
    
    return _sharedManager;
}

- (instancetype)initSingleton
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (instancetype)init
{
    return [DataManager sharedManager];
}

- (instancetype)new
{
    return [DataManager sharedManager];
}

-(void)getNotesList:(ArrayDataCallback)callback {
    [[WebManager sharedManager] notesRequest:^(BOOL error, NSString *message, NSData *data) {
        NSMutableArray *notes = [[NSMutableArray alloc] init];
        NSArray *array;
        if(!error) {
            NSError *e;

            array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&e];
            for(NSDictionary *noteDictionary in array) {
                Note *note = [[Note alloc] init];
                note.noteId = [[noteDictionary valueForKey:@"id"] integerValue];
                note.content = [noteDictionary objectForKey:@"text"];
                NSString *datetime = [noteDictionary objectForKey:@"datetime"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
                NSDate *date = [dateFormatter dateFromString:datetime];
                note.date = date;
                [notes addObject:note];
            }
        }
        callback(error, message, notes);
    }];
}

- (void)createNote:(NSString *)text datetime:(NSString *)datetime callback:(StringCallback)callback {
    [[WebManager sharedManager] createNoteRequest:text datetime:datetime callback:^(BOOL error, NSString *message, NSData *data) {
        NSString *token = @"";

        if(!error) {
            NSError *e;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            if(!e) {
                token = [dictionary valueForKey:@"token"];
                [WebManager sharedManager].token = token;
            } else {
                message = @"";
            }
            callback(e, message, token);
        } else {
            callback(error, message, token);
        }
    }];
}

- (void)updateNote:(NSString *)text noteId:(NSInteger)noteId callback:(StringCallback)callback {
    [[WebManager sharedManager] updateNoteRequest:text noteId:noteId callback:^(BOOL error, NSString *message, NSData *data) {
        callback(error, message, nil);
    }];
}

- (void)deleteNote:(NSInteger )noteId callback:(StringCallback)callback {
    [[WebManager sharedManager] deleteNoteRequest:noteId callback:^(BOOL error, NSString *message, NSData *data) {
        callback(error, message, nil);
    }];
}


-(void)login:(NSString *)username password:(NSString *)password callback:(StringCallback)callback {
    NSString *encryptedPassword = [password MD5String];
    [[WebManager sharedManager] loginRequest:username encryptedPassword: encryptedPassword callback:^(BOOL error, NSString *message, NSData *data) {
        NSString *token = @"";
        if(!error) {
            NSError *e;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            if(!e) {
                token = [dictionary valueForKey:@"token"];
                [WebManager sharedManager].token = token;
            } else {
                message = @"";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(e, message, token);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(error, message, token);
            });
        }

    }];
}
@end
