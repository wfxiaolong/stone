//
//  ContactController.m
//  datoucontacts
//
//  Created by houwenjie on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContactController.h"
#import "pinyin.h"
#import "POAPinyin.h"
#import "FriendListCell.h"
#import "UIImageView+WebCache.h"

#import "RWRCChatViewController.h"

@interface ContactController ()

@property (nonatomic, strong) NSMutableDictionary *sectionDic;
@property (nonatomic, strong) NSMutableArray *filterArray;

@end

@implementation ContactController

static NSString *CellIdentifier = @"ContactCellIdentify";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///NavigationTitle
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    customLab.textAlignment = NSTextAlignmentCenter;
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"联系人"];
    customLab.font = [UIFont systemFontOfSize: 18.0f];
    self.navigationItem.titleView = customLab;
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    
    ///ButtonItem
    CGRect leftframe = CGRectMake(0, 0, 18, 20);
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:leftframe];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    CGRect rightframe = CGRectMake(0, 0, 28, 30);
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:rightframe];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_friend_add"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    ///TableView
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor blueColor];
    self.tableView.rowHeight = 50;
    self.sectionDic = [[NSMutableDictionary alloc] init];
    self.filterArray = [[NSMutableArray alloc] init];
    
    [self loadContacts];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
    
    self.searchDisplayController.searchResultsTableView.rowHeight = 50;
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"FriendListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![self.searchDisplayController isActive]) {
        [self loadContacts];
        [self.tableView reloadData];
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)leftBarButtonItemPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemPressed:(UIButton *)sender {
    
}

-(void)loadContacts {
    [_sectionDic removeAllObjects];
    for (int i = 0; i < 26; i++) [_sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'A'+i]];
    [_sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'#']];
    
    //遍历所有联系人
    for (int k=0; k<_dataArray.count; k++) {
        NSString *personname = _dataArray[k][@"name"];
        char first=pinyinFirstLetter([personname characterAtIndex:0]);
        NSString *sectionName;
        if ((first>='a'&&first<='z')||(first>='A'&&first<='Z')) {
            if([self searchResult:personname searchText:@"曾"])
                sectionName = @"Z";
            else if([self searchResult:personname searchText:@"解"])
                sectionName = @"X";
            else if([self searchResult:personname searchText:@"仇"])
                sectionName = @"Q";
            else if([self searchResult:personname searchText:@"朴"])
                sectionName = @"P";
            else if([self searchResult:personname searchText:@"查"])
                sectionName = @"Z";
            else if([self searchResult:personname searchText:@"能"])
                sectionName = @"N";
            else if([self searchResult:personname searchText:@"乐"])
                sectionName = @"Y";
            else if([self searchResult:personname searchText:@"单"])
                sectionName = @"S";
            else
            sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([personname characterAtIndex:0])] uppercaseString];
        } else {
            sectionName = [[NSString stringWithFormat:@"%c",'#'] uppercaseString];
        }
        [[_sectionDic objectForKey:sectionName] addObject:_dataArray[k]];
    }
}

#pragma mark - Table View

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.tableView]) {
    NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (int i = 0; i < 27; i++)
            [indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
    return indices;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (title == UITableViewIndexSearch) {
		[self.tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
		return -1;
	}
   return  [ALPHA rangeOfString:title].location;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.tableView]) {
        return 27;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        NSString *key=[NSString stringWithFormat:@"%c", [ALPHA characterAtIndex:section]];
        return  [[_sectionDic objectForKey:key] count];
    }
   return [self.filterArray count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return nil;
    }
    NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:section]];
    if ([[_sectionDic objectForKey:key] count]!=0) {
        return key;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *person;
    if (![tableView isEqual:self.tableView]) {
        person = [self.filterArray objectAtIndex:indexPath.row];
    } else {
        NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:indexPath.section]];
        person = [_sectionDic objectForKey:key][indexPath.row];
    }
    cell.friendName.text=[person objectForKey:@"name"];
    [cell.friendImg sd_setImageWithURL:[NSURL URLWithString:person[@"portrait"]] placeholderImage:[UIImage imageNamed:@"portrait"]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *person;
    if (![tableView isEqual:self.tableView]) {
        person = [self.filterArray objectAtIndex:indexPath.row];
    } else {
        NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:indexPath.section]];
        person = [_sectionDic objectForKey:key][indexPath.row];
    }
    
    RWRCChatViewController *chatViewController = [[RWRCChatViewController alloc] init];
    chatViewController.currentTarget = person[@"fid"];
    chatViewController.currentTargetName = person[@"name"];
    chatViewController.portraitStyle = RCUserAvatarCycle;
    chatViewController.conversationType = ConversationType_PRIVATE;
    
    chatViewController.navigationController.navigationItem.title = person[@"name"];
    
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:chatViewController animated:YES];
    
}

#pragma UISearchDisplayDelegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self performSelectorOnMainThread:@selector(searchWithString:) withObject:searchString waitUntilDone:YES];

    return YES;
}

-(void)searchWithString:(NSString *)searchString {
    [self.filterArray removeAllObjects];
    if ([searchString length]!=0) {
        NSString *sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([searchString characterAtIndex:0])] uppercaseString];
        NSArray *array=[_sectionDic objectForKey:sectionName];
        for (int j=0;j<[array count];j++) {
            NSDictionary *person=[array objectAtIndex:j];
            NSString *name = person[@"name"];
            if ([self searchResult:name searchText:searchString]) {
                //先按输入的内容搜索
                [self.filterArray addObject:person];
            } else {
                // 拼音
                NSString *string = @"";
                NSString *firststring=@"";
                for (int i = 0; i < [name length]; i++)
                {
                    if([string length] < 1)
                        string = [NSString stringWithFormat:@"%@",
                                  [POAPinyin quickConvert:[name substringWithRange:NSMakeRange(i,1)]]];
                    else
                        string = [NSString stringWithFormat:@"%@%@",string,
                                  [POAPinyin quickConvert:[name substringWithRange:NSMakeRange(i,1)]]];
                    if([firststring length] < 1)
                        firststring = [NSString stringWithFormat:@"%c",
                                       pinyinFirstLetter([name characterAtIndex:i])];
                    else
                    {
                        if ([name characterAtIndex:i]!=' ') {
                            firststring = [NSString stringWithFormat:@"%@%c",firststring,
                                           pinyinFirstLetter([name characterAtIndex:i])];
                        }
                        
                    }
                }
                if ([self searchResult:string searchText:searchString]
                    ||[self searchResult:firststring searchText:searchString])
                {
                    NSMutableDictionary *record=[[NSMutableDictionary alloc] init];
                    [record setObject:name forKey:@"name"];
                    [record setObject:person[@"portrait"] forKey:@"Img"];
                    [record setObject:person[@"fid"] forKey:@"ID"];
                    [self.filterArray addObject:record];
                }
            }
        }
    }
}

-(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
	NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
											   range:NSMakeRange(0, searchT.length)];
	if (result == NSOrderedSame)
		return YES;
	else
		return NO;
}

@end
