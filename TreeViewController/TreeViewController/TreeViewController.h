//
//  TreeViewController.h
//  TreeViewController
//
//  Created by YehYungCheng on 2016/4/21.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"

@interface TreeViewController : UITableViewController
@property (nonatomic)id treeData;
@property Boolean expandable;
@property (nonatomic, weak) id treeDataDelegate;
@end

@protocol TreeDataDelegate <NSObject>
@optional
- (void)treeViewController:(TreeViewController *)treeViewController clickAtNode:(TreeViewNode*)node;
@end
