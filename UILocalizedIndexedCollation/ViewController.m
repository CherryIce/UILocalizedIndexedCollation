//
//  ViewController.m
//  UILocalizedIndexedCollation
//
//  Created by Macx on 2017/11/27.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ViewController.h"

#import "TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnClick:(UIButton *)sender
{
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[[TableViewController alloc] init]];
    [self presentViewController:nav animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
