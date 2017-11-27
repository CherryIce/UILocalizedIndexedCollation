//
//  TableViewController.m
//  UILocalizedIndexedCollation
//
//  Created by Macx on 2017/11/27.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "TableViewController.h"

#import "ShowModel.h"

@interface TableViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic,strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;

@end

@implementation TableViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UILocalizedIndexedCollation搜索";
    
    [self ShowUI];
}

- (void) ShowUI
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:[UITableViewController new]];
    self.searchController.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    
    UISearchBar *bar = self.searchController.searchBar;
    bar.barStyle = UIBarStyleDefault;
    bar.translucent = YES;
    bar.barTintColor = [UIColor colorWithRed:(248 / 255.0) green:(248 / 255.0) blue:(248 / 255.0) alpha:1];
    bar.tintColor = [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1];
    UIImageView *view = [[[bar.subviews objectAtIndex:0] subviews] firstObject];
    view.layer.borderColor = [UIColor colorWithRed:(248 / 255.0) green:(248 / 255.0) blue:(248 / 255.0) alpha:1].CGColor;
    view.layer.borderWidth = 1;
    
    bar.layer.borderColor = [UIColor redColor].CGColor;
    
    bar.showsBookmarkButton = YES;
    [bar setImage:[UIImage imageNamed:@"UISearchBarIconBookmark"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    bar.delegate = self;
    CGRect rect = bar.frame;
    rect.size.height = 44;
    bar.frame = rect;
    self.tableView.tableHeaderView = bar;
    self.tableView.rowHeight = 50;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self loadData:30];
    
    self.tableView.sectionHeaderHeight = 25;
}

- (void)loadData:(NSInteger)count
{
    
    NSArray *xings = @[@"赵",@"钱",@"孙",@"李",@"胡",@"吴",@"阿",@"毕",@"冯",@"陈",@"大",@"娿",@"蒋",@"沈",@"韩",@"杨"];
    NSArray *ming1 = @[@"大",@"美",@"帅",@"应",@"超",@"海",@"江",@"湖",@"春",@"夏",@"秋",@"冬",@"上",@"左",@"有",@"纯"];
    NSArray *ming2 = @[@"强",@"好",@"领",@"亮",@"超",@"华",@"奎",@"海",@"工",@"青",@"红",@"潮",@"兵",@"垂",@"刚",@"山"];
    
    for (int i = 0; i < count; i++) {
        NSString *name = xings[arc4random_uniform((int)xings.count)];
        NSString *ming = ming1[arc4random_uniform((int)ming1.count)];
        name = [name stringByAppendingString:ming];
        if (arc4random_uniform(10) > 3) {
            NSString *ming = ming2[arc4random_uniform((int)ming2.count)];
            name = [name stringByAppendingString:ming];
        }
        ShowModel *model = [ShowModel new];
        model.showString = name;
        [self.dataArray addObject:model];
    }
    
    [self setUpTableSection];
}

- (void) setUpTableSection {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Persons info into newSectionArray
    for (ShowModel *model in self.dataArray) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(showString)];
        [newSectionArray[sectionIndex] addObject:model];
    }
    
    //sort the person of each section
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(showString)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];

    self.sectionArray = newSectionArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ShowModel * model = self.sectionArray[indexPath.section][indexPath.row];
    cell.textLabel.text = model.showString;
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionTitlesArray objectAtIndex:section];
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitlesArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    
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
