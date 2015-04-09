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

-(void) loadObjects {
    [IQApplication allApplications:^(NSArray *applications, NSError *error) {
        _applications = applications;
        [self.tableView reloadData];
        if(error) NSLog(@"Failed to InfantIQ Applications Table View due to error:%@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _applications.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"infantIQAppCell";
    IQApplicationTableCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[IQApplicationTableCellView alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.application = _applications[(NSUInteger) indexPath.row];

    return cell;
}

@end