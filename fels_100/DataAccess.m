//
//  DataAccess.m
//  fels_100
//
//  Created by Tahia Ata on 12/24/15.
//  Copyright © 2015 Abu Khalid. All rights reserved.
//

#import "DataAccess.h"

@implementation DataAccess

- (AFHTTPSessionManager *) getManager {
    NSString *urlString = BASEURL;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString] sessionConfiguration:configuration];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    return manager;
}

- (void)signUp:(NSString *)name email:(NSString *)email password:(NSString *)password confirm:(NSString *)confirmPassword complete:(void(^)(BOOL check))completionBlock {
    NSDictionary *param = @{@"user":@{@"name":name,
                                      @"email":email,
                                      @"password":password,
                                      @"password_confirmation":confirmPassword}};
   [[self getManager] POST:@"users.json" parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(YES);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(NO);
    }];
}

- (void)signIn:(NSString *)email password:(NSString *)password remember:(NSNumber *)rememberMe complete:(void(^)(BOOL isLogged,NSDictionary *theDic))completionBlock {
    if (email && password && rememberMe) {
        NSDictionary *param = @{@"session":@{@"email":email,
                                             @"password":password,
                                             @"remember_me":rememberMe}};
        [[self getManager] POST: @"login.json" parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"Sign in:%@",responseObject);
            NSDictionary *theDictionary = [(NSDictionary *)responseObject objectForKey:@"user"];
            if (theDictionary && [theDictionary objectForKey:@"id"] && [theDictionary objectForKey:@"auth_token"]) {
                NSDictionary *temporaryDictionary = @{@"id":[theDictionary objectForKey: @"id"],
                                                      @"authToken":[theDictionary objectForKey: @"auth_token"]};
                completionBlock(YES,temporaryDictionary);
            } else {
                completionBlock(NO,@{});
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            completionBlock(NO,@{});
        }];
    } else {
        completionBlock(NO,@{});
    }
}

@end
