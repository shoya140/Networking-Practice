//
//  ViewController.h
//  Networking-Practice
//
//  Created by Shoya Ishimaru on 2014/08/30.
//  Copyright (c) 2014年 shoya140. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
