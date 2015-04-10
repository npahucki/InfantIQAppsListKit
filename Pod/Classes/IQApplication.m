//
//  IQApplication.m
//  Pods
//
//  Created by Nathan  Pahucki on 4/7/15.
//
//

#import "IQApplication.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation IQApplication

+ (NSArray *) applicationsFromData:(NSData *) data error:(NSError * *) error {
    NSMutableArray * applications = [[NSMutableArray alloc] init];
    id topObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    if([topObject isKindOfClass:[NSArray class]]) {
        applications = [[NSMutableArray alloc] init];
        for(NSDictionary * obj in topObject) {
            IQApplication * app = [[IQApplication alloc] init];
            app.title = obj[@"title"];
            app.appBundleId = obj[@"bundleId"];
            app.longDescription = obj[@"description"];
            app.finePrint = obj[@"finePrint"];
            app.appStoreId = obj[@"appStoreId"];
            app.mainColor = UIColorFromRGB(((NSNumber *)obj[@"color"]).intValue);
            [applications addObject:app];
        }
    }
    return applications;
}

- (void)fetchImage:(IQApplicationImageResultBlock)block {
    [IQApplication loadResource:self.appBundleId ofType:@"png" withBlock:^(NSData *imageData, NSError *error) {
        UIImage * image = [UIImage imageWithData:imageData];
        if(image) block(image);
        if(error) NSLog(@"Could not fetch image for applicaiton %@. Error:%@", self.appBundleId, error);
    }];
}

// This method will call the block one or times.
// Once if there is a cached result OR default available,
// and once more if there is an UPDATED version of the resource available.
// NOTE: We DON'T use the caching that comes built into NSURLSession because we want to fall back to a local default
// which can't be done when using the default caching.
+(void) loadResource:(NSString*) name ofType:(NSString *) type withBlock:(IQApplicationDataResultBlock) block {
    BOOL blockCalled = NO;
    NSString * url =  [NSString stringWithFormat:@"%@%@.%@",INFANTIQ_APP_LIST_URL_BASE, name, type];
    NSString *cacheFilePath = [NSString stringWithFormat:@"%@%@.%@",NSTemporaryDirectory(), name, type];
    NSData * data = [NSData dataWithContentsOfFile:cacheFilePath];
    if(!data) {
        // Cache miss..try to load a default from bundle
        NSString *resourceBundlePath = [[NSBundle mainBundle] pathForResource:@"InfantIQAppsKit" ofType:@"bundle"];
        NSBundle *infantIqBundle = [NSBundle bundleWithPath:resourceBundlePath];
        NSString *file = [infantIqBundle pathForResource: name ofType: type];
        data = [NSData dataWithContentsOfFile:file];
    }
    if(data) {
        block(data, nil);
        blockCalled = YES;
    }


    NSFileManager* fm = [NSFileManager defaultManager];
    NSDictionary* attrs = [fm attributesOfItemAtPath:cacheFilePath error:nil];
    NSDate *cacheFileCreatedDate = (NSDate*) attrs.fileModificationDate;
    NSDateFormatter *rfc2822Formatter = [[NSDateFormatter alloc] init];
    rfc2822Formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z"; //RFC2822-Format
    rfc2822Formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];

    // Don't bother even checking more than once a day
    NSDate * cacheFileValidUntilDate = [cacheFileCreatedDate dateByAddingTimeInterval:24 * 60 * 60];
    if ([[NSDate date] compare:cacheFileValidUntilDate] == NSOrderedAscending) {
        NSLog(@"Cache period of one day still not exceeded for resource %@", url);
        return;
    }
    // Ok, we already either called the block with the results of the cache or default
    // We will call again now if we can load the data from the URL specified.
    // We will also update the cache.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    // Don't download stuff we already have cached.
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    if(cacheFileCreatedDate) [request setValue:[rfc2822Formatter stringFromDate:cacheFileCreatedDate] forHTTPHeaderField:@"If-Modified-Since"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *remoteData, NSURLResponse *response, NSError *remoteError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // In the case of non 200, then neither data nor error will be set
            if(((NSHTTPURLResponse *)response).statusCode == 200) {
                block(remoteData, remoteError);
                [remoteData writeToFile:cacheFilePath atomically:NO];
            } else if (!blockCalled && remoteError) {
                block(nil, remoteError);
            } else {
                NSLog(@"Recieved response code %d for resource %@. Return message:%@",((NSHTTPURLResponse *)response).statusCode,url,
                        [[NSString alloc] initWithData:remoteData encoding:NSUTF8StringEncoding]);
            }
        });
    }];
    
    [task resume];
}

+ (void)allOtherApplications:(IQApplicationListResultBlock)block {
    [self allApplications:^(NSArray *applications, NSError *error) {
        if(applications.count) {
            NSUInteger idxToRemove = 0;
            for(IQApplication * app in applications) {
                if([app.appBundleId isEqualToString:[[NSBundle mainBundle] bundleIdentifier]]) {
                    break;
                }
                idxToRemove++;
            }
            if(idxToRemove < applications.count) {
                [((NSMutableArray *) applications) removeObjectAtIndex:idxToRemove];
            }
        }
        block(applications,error);
    }];
}


+ (void)allApplications:(IQApplicationListResultBlock)block {
    [self loadResource:@"InfantIQAppsList" ofType:@"json" withBlock:^(NSData *data, NSError *error) {
        NSArray * applications;
        if(data.length) applications = [self applicationsFromData:data error:&error];
        block(applications, error);
    }];
}


@end
