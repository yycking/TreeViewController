//
//  TreeViewNode.h
//  TreeViewController
//
//  Created by YehYungCheng on 2016/4/23.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeViewNode: NSObject
@property id data;
@property NSInteger level;
@property NSString *text;
@property Boolean expand;
@property NSMutableArray<TreeViewNode*> *children;
@end
