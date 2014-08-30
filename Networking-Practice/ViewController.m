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
#import "UIImageView+WebCache.h"

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = items[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    label.text = item[@"title"];
    
    NSString *imageURLString = @"";
    NSString *content = item[@"content:encoded"];
    NSString *pattern = @"(<img.*?src=\\\"http://cdn-ak.b.st-hatena.com/entryimage/)(.*?)(.jpg\\\".*?>)";
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error){
        NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
        for (NSTextCheckingResult *match in matches){
            imageURLString = [NSString stringWithFormat:@"http://cdn-ak.b.st-hatena.com/entryimage/%@_l.jpg", [content substringWithRange:[match rangeAtIndex:2]]];
        }
    }
    
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    [imageView sd_setImageWithURL:imageURL
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (cacheType != SDImageCacheTypeMemory) {
                                [UIView transitionWithView:imageView
                                                  duration:0.28 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                                animations:nil
                                                completion:nil];
                            }
                        }];
    
    return cell;
 }

@end
