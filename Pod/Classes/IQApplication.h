//
//  IQApplication.h
//  Pods
//
//  Created by Nathan  Pahucki on 4/7/15.
//
//

#import <UIKit/UIKit.h>

#define INFANTIQ_APP_LIST_URL_BASE @"https://s3.amazonaws.com/infantiq-appinfo/"

typedef void (^IQApplicationListResultBlock)(NSArray * applications, NSError *error);
typedef void (^IQApplicationImageResultBlock)(UIImage * image);
typedef void (^IQApplicationDataResultBlock)(NSData * image, NSError *error);


@interface IQApplication : NSObject

@property NSString * appBundleId;
@property NSString * title;
@property UIColor * mainColor;
@property NSString * appStoreUrl;
@property NSString * longDescription;
@property NSString * finePrint;


-(void) fetchImage:(IQApplicationImageResultBlock)block;

+(void) allApplications:(IQApplicationListResultBlock)block;


@end
