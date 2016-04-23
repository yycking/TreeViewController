//
//  TreeViewController.m
//  TreeViewController
//
//  Created by YehYungCheng on 2016/4/21.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

#import "TreeViewController.h"

@interface TreeViewController ()
@property NSMutableArray<TreeViewNode*> *arrayData;
@property TreeViewNode *tree;
@end

@implementation TreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma maek - Public function
- (void)setTreeData:(id)treeData {
    _treeData = treeData;
    
    // create data tree and array data for table view
    self.tree = [self createNodeWithObject:treeData withLevel:0];
    self.arrayData = [self.tree.children mutableCopy];
}

#pragma maek - Private function
- (TreeViewNode*)createNodeWithObject:(id)object withLevel:(NSInteger)level {
    TreeViewNode *node = [TreeViewNode new];
    node.level = level;
    node.data = object;
    
    level++;
    // create children node for current node
    if ([object isKindOfClass:[NSDictionary class]]) {
        node.children = [NSMutableArray array];
        for (NSString* key in object) {
            id subObject = [object objectForKey:key];
            TreeViewNode *subNode = [self createNodeWithObject:subObject withLevel:level];
            subNode.text = key;
            [node.children addObject:subNode];
        }
    } else if ([object isKindOfClass:[NSArray class]]) {
        node.children = [NSMutableArray array];
        for (id subObject in object) {
            TreeViewNode *subNode = [self createNodeWithObject:subObject withLevel:level];
            [node.children addObject:subNode];
        }
    }else{
        node.text = object;
    }
    
    return node;
}

#pragma maek - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TreeViewNode *node = [self.arrayData objectAtIndex:indexPath.row];
    
    if (node.children) {
        if (self.expandable) {
            node.expand = !node.expand;
            
            // update current node
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
            if (node.expand) {
                // show all children
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, node.children.count)];
                NSMutableArray *indexPaths = [NSMutableArray array];
                for (int i=0; i< node.children.count; i++) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row+i+1 inSection:0]];
                }
                
                [self.arrayData insertObjects:node.children atIndexes:indexSet];
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            } else {
                // hide all children and grandchild
                int count = node.children.count;
                NSMutableArray *indexPaths = [NSMutableArray array];
                for (int i=0; i< count; i++) {
                    int index = indexPath.row+1+i;
                    TreeViewNode *subNode = [self.arrayData objectAtIndex:index];
                    if (subNode.expand) {
                        subNode.expand = !subNode.expand;
                        count += subNode.children.count;
                    }
                    [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                }
                
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, count)];
                [self.arrayData removeObjectsAtIndexes:indexSet];
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }
        } else {
            // show sub children on new view
            TreeViewController *subController = [TreeViewController new];
            subController.treeData = node.data;
            subController.treeDataDelegate = self.treeDataDelegate;
            if (self.navigationController != nil) {
                [self.navigationController pushViewController:subController animated:YES];
            } else {
                [self presentViewController:subController animated:YES completion:nil];
            }
        }
    } else {
        if ([self.treeDataDelegate respondsToSelector:@selector(treeViewController:clickAtNode:)])
        {
            [self.treeDataDelegate treeViewController:self clickAtNode:node];
        }
    }
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData? [self.arrayData count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"reuseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // Configure the cell...
    TreeViewNode *node = [self.arrayData objectAtIndex:indexPath.row];
    NSMutableString *txet = [NSMutableString stringWithString:@""];;
    if (self.expandable) {
        for (int i=1; i<node.level; i++) {
            [txet appendString:@" "];
        }
        if (node.children) {
            if (node.expand) {
                [txet appendString:@"－"];
            } else {
                [txet appendString:@"＋"];
            }
        } else {
            [txet appendString:@" "];
        }
        [txet appendString:@" "];
    }
    [txet appendString:node.text];
    cell.textLabel.text = txet;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
