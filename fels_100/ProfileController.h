//
//  ProfileController.h
//  fels_100
//
//  Created by Tahia Ata on 12/23/15.
//  Copyright © 2015 Abu Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileController : UIViewController

@property (strong, nonatomic) NSString *theID;
@property (strong, nonatomic) NSString *auth_token;

- (IBAction)logoutButton:(id)sender;

@end
