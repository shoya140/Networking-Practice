//
//  ViewController.m
//  Networking-Practice
//
//  Created by Shoya Ishimaru on 2014/08/30.
//  Copyright (c) 2014年 shoya140. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "DDXML.h"
#import "DDXMLElement+Dictionary.h"

@interface ViewController (){
    NSArray *items;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    items = @[];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://b.hatena.ne.jp/hotentry"
      parameters:@{@"mode":@"rss"}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSError *error = nil;
             DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:(NSData *)responseObject options:0 error:&error];
             if (!error) {
                 NSDictionary *xml = [doc.rootElement convertDictionary];
                 items = xml[@"rdf:RDF"][@"item"];
                 [self.tableView reloadData];
             } else {
                 NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = items[indexPath.row][@"title"];
    return cell;
 }

@end
