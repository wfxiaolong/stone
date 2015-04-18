//
//  ContactController.h
//  datoucontacts
//
//  Created by houwenjie on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactController : UITableViewController<UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDictionary *dataDic;

-(void)loadContacts;

@end
