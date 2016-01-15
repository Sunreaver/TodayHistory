//
//  AddAndShowDataTVC.m
//  PassWord
//
//  Created by 谭伟 on 15/5/22.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "AddAndShowDataTVC.h"
#import "THReadBook.h"
#import "THReadList.h"
#import "UserDef.h"

@interface AddAndShowDataTVC ()
@property (weak, nonatomic) IBOutlet UITextField *tf_tip;
@property (weak, nonatomic) IBOutlet UITextField *tf_pwd;
@property (weak, nonatomic) IBOutlet UITextField *tf_acc;

@end

@implementation AddAndShowDataTVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && indexPath.row == 0)
    {//确定
        if (self.tf_tip.text.length == 0)
        {
            [self.tf_tip becomeFirstResponder];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else if (self.tf_pwd.text.length == 0)
        {
            [self.tf_pwd becomeFirstResponder];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else if (self.tf_acc.text.length == 0)
        {
            [self.tf_acc becomeFirstResponder];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else
        {
            NSArray<NSString*> *ar = [self.tf_tip.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",，"]];
            NSMutableString *author = [NSMutableString stringWithCapacity:self.tf_tip.text.length];
            for (int i = 1; i < ar.count; ++i)
            {
                [author appendString:ar[i]];
                [author appendString:@"，"];
            }
            if (author.length > 0) {
                [author deleteCharactersInRange:NSMakeRange(author.length - 1, 1)];
            }
            
            THRead *read = [THRead initWithBookName:ar[0] Author:author PageNum:[self.tf_pwd.text integerValue] Deadline:[self.tf_acc.text integerValue]];
            [THReadList AddData:read];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
