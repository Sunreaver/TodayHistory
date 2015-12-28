//
//  AddAndShowDataTVC.m
//  PassWord
//
//  Created by 谭伟 on 15/5/22.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "AddAndShowDataTVC.h"
#import "THRead.h"
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
            THRead *read = [THRead initWithBookName:self.tf_tip.text PageNum:[self.tf_pwd.text integerValue] Deadline:[self.tf_acc.text integerValue]];
            [THReadList AddData:read];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
