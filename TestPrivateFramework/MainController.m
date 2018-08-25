//
//  MainController.m
//  TestPrivateFramework
//
//  Created by Li Jun on 2018/8/23.
//  Copyright © 2018 Nextop.CN. All rights reserved.
//

#import "MainController.h"
#import <objc/runtime.h>
#import "Extensions.h"

@interface MainController()<UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *tvControllers;
}

@property(nonatomic, strong) NSArray<NSString *> *controllers;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.controllers = @[@"FTDeviceSupportTest",
                         @"CoreTelephonyTest"];
    //[tvControllers registerNib:[UINib nibWithNibName:@"UITableViewCell" bundle:nil] forCellReuseIdentifier:@"UITableViewCell"];
    [tvControllers registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.controllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self.controllers objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = title;
    return cell;
}

// MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *name = [self.controllers objectAtIndex:indexPath.row];
    Class cls = NSClassFromString(name);
    UIViewController *controller = [[cls alloc] initWithNibName:name bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
