//
// Created by Nathan  Pahucki on 4/7/15.
//

#import <UIKit/UIKit.h>
#import "IQApplication.h"


@protocol IQApplicationListDelegate <NSObject>

-(BOOL) shouldOpenApp:(IQApplication *) app;

@end

@interface IQApplicationListController : UITableViewController

@property CGFloat fadeBottomStart;
@property id <IQApplicationListDelegate> delegate;

@end