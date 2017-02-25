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
    
    config.readOnly = NO;
    int currentVersion = 10.0;
    config.schemaVersion = currentVersion;
    config.migrationBlock = ^(RLMMigration *migration , uint64_t oldSchemaVersion) {
        // 这里是设置数据迁移的block
        if (oldSchemaVersion < currentVersion) {
            
        }
    };
    
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

    UserMD *userMD;
    NSString *userId = @"200";
    // 查询当前是否有这个表
    if ([UserMD objectInRealm:_realm forPrimaryKey:userId]) {
        userMD = [UserMD objectInRealm:_realm forPrimaryKey:userId];
    }else {
        userMD = [UserMD new];
        userMD.userId = userId;
    }
    
    NSString *messageId = @"2000";
    [_realm transactionWithBlock:^{
        for (int i = 0; i < 100; i++) {
            UserMessageMD *userMessageMD;
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"messageId = %@",messageId];
            if([userMD.userMessages indexOfObjectWithPredicate:pred] != NSNotFound){
                NSUInteger index = [userMD.userMessages indexOfObjectWithPredicate:pred];
                userMessageMD = userMD.userMessages[index];
                NSLog(@"我是查询的结果%lu",index);
            }else{
                // 插入新的数据
                userMessageMD = [UserMessageMD new];
                userMessageMD.title = @"我是主标题";
                userMessageMD.subTitle = @123;
                userMessageMD.messageId = messageId;
                [userMD.userMessages addObject:userMessageMD];
            }
        }
        [UserMD createOrUpdateInRealm:_realm withValue:userMD];
    }];
}

// 查询
- (void) queryDatas {
    NSLog(@"%@",[UserMD allObjectsInRealm:_realm]);
}



@end
