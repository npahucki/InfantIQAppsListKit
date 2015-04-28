//
// Created by Nathan  Pahucki on 4/7/15.
//

#import "IQApplicationListController.h"
#import "IQApplication.h"
#import "IQApplicationTableCellView.h"


@implementation IQApplicationListController {
    NSArray * _applications;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadObjects];
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // Make the bottom of the Text field fade out
    if(self.fadeBottomStart > 0) {
        CAGradientLayer *l = [CAGradientLayer layer];
        l.frame = self.tableView.bounds;
        l.colors = @[(id) [UIColor whiteColor].CGColor, (id) [UIColor clearColor].CGColor];
        l.startPoint = CGPointMake(0.0f, self.fadeBottomStart);
        l.endPoint = CGPointMake(0.0f, 1.0f);
        self.tableView.layer.mask = l;
    }
}

-(void) loadObjects {
    [IQApplication allOtherApplications:^(NSArray *applications, NSError *error) {
        _applications = applications;
        [self.tableView reloadData];
        if(error) NSLog(@"Failed to InfantIQ Applications Table View due to error:%@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _applications.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IQApplicationTableCellView *cell = [self dequeOrCreateCell];
    cell.application = _applications[(NSUInteger) indexPath.row];
    return cell;
}

-(IQApplicationTableCellView *) dequeOrCreateCell {
    static NSString *CellIdentifier = @"infantIQAppCell";
    IQApplicationTableCellView *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[IQApplicationTableCellView alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor]; // This can not be set in IB...it seems to have no effect at all. 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IQApplicationTableCellView * cell = (IQApplicationTableCellView *) [self.tableView cellForRowAtIndexPath:indexPath];
    BOOL shouldOpen = YES;
    if([self.delegate respondsToSelector:@selector(shouldOpenApp:)]) {
        shouldOpen = [self.delegate shouldOpenApp:cell.application];
    }

    if(shouldOpen) {
        [cell.application openInAppStore];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel * label = [[UILabel alloc] init];
    label.textColor = [UIColor lightTextColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"Our Other Apps";
    CGSize labelSize =[label sizeThatFits:CGSizeMake(tableView.bounds.size.width, self.tableView.rowHeight / 2)];

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,0,labelSize.width, labelSize.height)];
    view.backgroundColor = [UIColor lightGrayColor];
    label.frame = CGRectMake(15,0,labelSize.width, labelSize.height); // 15 to match built in table cell indent
    [view addSubview:label];
    return view;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}



@end