//
// Created by Nathan  Pahucki on 4/7/15.
//

#import <UIKit/UIKit.h>
#import "IQApplication.h"

@interface IQApplicationTableCellView : UITableViewCell

@property IQApplication * application;
@property UIColor * textColor;
@property NSString * fontName;


- (CGFloat)estimatedHeightForWidth:(CGFloat)tableWidth;
@end