//
//  ViewController.m
//  RealmLearn
//
//  Created by MAC on 2016/12/12.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "PersonModel.h"
#import "UserMD.h"


@interface ViewController ()

@property (strong, nonatomic) RLMRealm *realm;
@property (strong, nonatomic) RLMResults<PersonModel *> *allPersons;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRealm];

}
    
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[self seletedData];
    [self queryDatas];
}

    
#pragma mark - 创建数据库（不创建使用系统默认）
- (BOOL) initRealm {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent]
                       URLByAppendingPathComponent:@"crud"]
                      URLByAppendingPathExtension:@"realm"];
    NSLog(@"Realm file path: %@", config.fileURL);
    NSError *error;
    _realm = [RLMRealm realmWithConfiguration:config error:&error];
    if (nil != error) {
        NSLog(@"Create Realm Error");
        return NO;
    }
    NSLog(@"create realm success");
    return YES;
}

#pragma mark - 增
- (void) insertData {
    PersonModel *model = [PersonModel new];
    model.name = @"hjq";
    model.age = 10000;
    model.personId = 123;
    
    [_realm transactionWithBlock:^{
        [_realm addObject:model];
    }];
    
    // 查询所有的
    _allPersons = [PersonModel allObjectsInRealm:_realm];
    
}
#pragma mark - 删
- (void) deletedData {
    PersonModel *person = _allPersons[0];
    [_realm transactionWithBlock:^{
        [_realm deleteObject:person];
    }];
    
}
#pragma mark - 改
- (void) updateData {
    PersonModel *person = _allPersons[0];
    [_realm transactionWithBlock:^{
        person.name = @"测试";
    }];
    
}
#pragma mark - 查
- (void) seletedData {
    // 条件查询
//    NSString *filter = [NSString stringWithFormat:@"age > %d", 100];
//    _allPersons = [PersonModel objectsInRealm:_realm where:filter];
    _allPersons = [PersonModel allObjects];
    NSLog(@"%@",_allPersons);
    
}
    
- (IBAction)addClick:(id)sender {
    //[self insertData];
    [self createTable];
    
}

#pragma mark - 一对多
// 创建表
- (void) createTable {

    UserMD *userMD = [UserMD new];
    userMD.userId = @"200";
    
    UserMessageMD *userMessageMD = [UserMessageMD new];
    userMessageMD.title = @"我是主标题";
    userMessageMD.subTitle = @"我是副标题";
    
    // 先查询后追加
    userMD.userMessages = [UserMD objectInRealm:_realm forPrimaryKey:userMD.userId].userMessages;

    [userMD.userMessages addObject:userMessageMD];
    
    [_realm transactionWithBlock:^{
        [_realm addOrUpdateObject:userMD];
    }];
}

// 查询
- (void) queryDatas {

    NSLog(@"%@",[UserMD allObjectsInRealm:_realm]);
}



@end
