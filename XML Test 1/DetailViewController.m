//
//  DetailViewController.m
//  XML Test 1
//
//  Created by Robert Ryan on 12/15/12.
//  Copyright (c) 2012 Robert Ryan. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewController.h"
#import "DetailViewController_B.h"

@implementation DetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.category[kCategoryNameKey];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *items = self.category[kCategoryProductsKey];
    
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *items = self.category[kCategoryProductsKey];
    NSDictionary *item = items[indexPath.row];
    
    cell.textLabel.text = item[kCategoryEnglishProductNameKey];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Item # %@", item[kCategoryProductCDKey]];
        
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailSegueB"])
    {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        DetailViewController_B *controller = segue.destinationViewController;
        
        NSLog(@"indexPathrow:%d",indexPath.row);
        //controller.category = self.categories[indexPath.row];
        
    }
}

@end
