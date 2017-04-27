//
//  WebManager.m
//  NotesExample
//
//  Created by Raphael Araújo on 4/3/17.
//  Copyright © 2017 araujoraphael. All rights reserved.
//

#import "WebManager.h"
#import <UIKit/UIKit.h>
@interface WebManager()
@property (nonatomic, strong) NSString *server;

@end

@implementation WebManager

+ (instancetype)sharedManager
{
    static WebManager *_sharedManager = nil;
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
        NSDictionary *mainDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Credentials" ofType:@"plist"]];
        _server = [mainDictionary objectForKey:@"API_URL"];
        _server = [_server stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    return self;
}

- (instancetype)init
{
    return [WebManager sharedManager];
}

- (instancetype)new
{
    return [WebManager sharedManager];
}

-(void)notesRequest:(DataWebCallback)callback {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest *url = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/notes?token=%@", self.server, self.token]]];
    [url setHTTPMethod:@"GET"];
    [url setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"token", self.token, nil];
//    url.HTTPBody = [NSJSONSerialization dataWithJSONObject:dictionary options:0
//                                                     error:nil];
    [self webRequest:url callback:^(BOOL error, NSString *message, NSData *data) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        callback(error, message, data);
    }];
}

- (void)createNoteRequest:(NSString *)text datetime:(NSString *)datetime callback:(DataWebCallback)callback {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest *url = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/notes", self.server]]];
    [url setHTTPMethod:@"POST"];
    [url setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.token, @"token", text, @"text",  datetime, @"datetime", nil];
    url.HTTPBody = [NSJSONSerialization dataWithJSONObject:dictionary options:0
                                                     error:nil];
    [self webRequest:url callback:^(BOOL error, NSString *message, NSData *data) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        callback(error, message, data);
    }];
}

- (void)updateNoteRequest:(NSString *)text noteId:(NSInteger)noteId callback:(DataWebCallback)callback {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest *url = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/notes/%ld", self.server, noteId]]];
    [url setHTTPMethod:@"PUT"];
    [url setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.token, @"token", text, @"text", nil];
    url.HTTPBody = [NSJSONSerialization dataWithJSONObject:dictionary options:0
                                                     error:nil];
    
    [self webRequest:url callback:^(BOOL error, NSString *message, NSData *data) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        callback(error, message, data);
    }];
}

- (void)deleteNoteRequest:(NSInteger )noteId callback:(DataWebCallback)callback {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest *url = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/notes/%ld", self.server, noteId]]];
    [url setHTTPMethod:@"DELETE"];
    [url setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [url setValue:self.token forHTTPHeaderField:@"token"];

    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.token, @"token", nil];
    url.HTTPBody = [NSJSONSerialization dataWithJSONObject:dictionary options:0
                                                     error:nil];

    [self webRequest:url callback:^(BOOL error, NSString *message, NSData *data) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        callback(error, message, data);
    }];
}
- (void)loginRequest:(NSString *)username encryptedPassword:(NSString *)encryptedPassword callback:(DataWebCallback)callback {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest *url = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/login", self.server]]];
    [url setHTTPMethod:@"POST"];
    [url setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:encryptedPassword, @"password", username, @"username",   nil];
    url.HTTPBody = [NSJSONSerialization dataWithJSONObject:dictionary options:0
                                                                        error:nil];
    [self webRequest:url callback:^(BOOL error, NSString *message, NSData *data) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        if(!error) {
            NSError *e = nil;
            if(e) {
                message = @"error parsing data response";
                callback(e, message, data);
            } else {
                callback(error, message, data);
            }
        } else {
            callback(error, message, data);
        }
    }];
}

- (void)webRequest:(NSMutableURLRequest *)request callback:(DataWebCallback)callback {
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(backgroundQueue, ^{
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *message = @"";
            
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
            if(!error) {
                BOOL e = NO;
                if(HTTPResponse.statusCode == 200) {
                    message = [NSString stringWithFormat:@"%ld - Success", (long)HTTPResponse.statusCode];
                } else {
                    message = [NSString stringWithFormat:@"%ld - Request error", (long)HTTPResponse.statusCode];
                    e = YES;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(e, message, data);
                });            } else {
                message = [NSString stringWithFormat:@"%ld - Error parsing the answer", (long)HTTPResponse.statusCode];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(error, message, data);
                });

            }
        }];
        
        [dataTask resume];
    });
}
- (NSMutableURLRequest *)request:(NSString *)service method:(NSString *)method body:(NSData *)body
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.server, service]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = method;
    request.HTTPBody = body;
    
    return request;
}
@end
