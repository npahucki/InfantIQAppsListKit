//
// Created by Nathan  Pahucki on 4/7/15.
//

#import "IQApplicationTableCellView.h"
#import "IQApplication.h"


@implementation IQApplicationTableCellView {
   IQApplication * _application;
}

- (IQApplication *)application {
    return _application;
}

- (void)setApplication:(IQApplication *)application {
    _application = application;
    NSAttributedString *lf = [[NSAttributedString alloc] initWithString:@"\n"];
    NSAttributedString *descriptionString = [[NSAttributedString alloc] initWithString:application.longDescription attributes:@{
            NSFontAttributeName : [UIFont systemFontOfSize:16],
            NSForegroundColorAttributeName : [UIColor grayColor]

    }];
    NSAttributedString *detailsString = [[NSAttributedString alloc] initWithString:application.finePrint attributes:@{
            NSFontAttributeName : [UIFont systemFontOfSize:10],
            NSForegroundColorAttributeName : [UIColor grayColor]
    }];

    NSMutableAttributedString *fullString = [[NSMutableAttributedString alloc] initWithAttributedString:descriptionString];
    [fullString appendAttributedString:lf];
    [fullString appendAttributedString:detailsString];

    self.textLabel.text = application.title;
    self.textLabel.font = [UIFont boldSystemFontOfSize:18];
    self.textLabel.textColor = application.mainColor;
    
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.attributedText = fullString;
    
    [application fetchImage:^(UIImage *image) {
        self.imageView.image = image;
    }];
}


@end