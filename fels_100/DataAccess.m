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

- (void )getCategories:(NSNumber*)page authenticationToken:(NSString*)authenticationToken complete:(void (^)(bool check ,NSDictionary* categoriesdict))completionBlock {
    NSDictionary *param = @{ @"page":page,
                             @"auth_token":authenticationToken};
    [[self getManager] GET:@"categories.json" parameters:param progress:nil
        success:^( NSURLSessionTask *task, id responseObject) {
            completionBlock(YES, responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            completionBlock(NO,@{});
    }];
}


- (void)fetchData:(NSString *)theID Token:(NSString *)authToken complete:(void(^)(BOOL check,NSDictionary *dictionary))completionBlock {
    if (theID && authToken) {
        NSString *path = [NSString stringWithFormat: @"users/%@.json",theID];
        [[self getManager] GET:path parameters:@{@"auth_token":authToken} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSDictionary *theDictionary = [(NSDictionary *)responseObject objectForKey:@"user"];
            if (theDictionary && [theDictionary objectForKey:@"name"] && [theDictionary objectForKey:@"email"] && [theDictionary objectForKey:@"avatar"] && [theDictionary objectForKey:@"activities"] && [theDictionary objectForKey:@"learned_words"]) {
                NSDictionary *temporaryDictionary = @{@"name":[theDictionary objectForKey: @"name"],
                                                      @"email":[theDictionary objectForKey:@"email"],
                                                      @"avatar":[theDictionary objectForKey: @"avatar"],
                                                      @"learned_words":[theDictionary objectForKey: @"learned_words"],
                                                      @"activities":[theDictionary objectForKey: @"activities"]};
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

-(void )getCategorieTypeWiseLesson:(NSString *) CategoryTypeId authenticationToken:(NSString*)authenticationToken complete:(void (^)(bool check ,NSDictionary* lessonDictionary))completionBlock {
    if(authenticationToken != nil){
        NSDictionary *param = @{ @"auth_token": authenticationToken};
        NSString* url= [NSString stringWithFormat:@"categories/%@/lessons.json", CategoryTypeId];
        [[self getManager] POST:url parameters:param progress:nil
                        success:^( NSURLSessionTask *task, id responseObject) {
                            //NSLog(@" %@", responseObject);
                            completionBlock(YES,responseObject);
                        } failure:^(NSURLSessionTask *operation, NSError *error) {
                            completionBlock(NO,@{});
        }];
      }
    }
    
- (void)categoryId:(NSNumber *)categoryId option:(NSString *)option page:(NSNumber *)page authToken:(NSString *)authToken complete:(void(^)(NSDictionary *wordsReturn))completionBlock {
        if (categoryId && option && page && authToken) {
            NSDictionary *param = @{ @"category_id": categoryId,
                                     @"option": option,
                                     @"page": page,
                                     @"auth_token": authToken };
            
            [[self getManager] GET:@"words.json" parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                completionBlock(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error:%@", error);
                completionBlock(@{});
            }];
        }
        
    }

@end


