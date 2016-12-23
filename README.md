# 一、初始化Realm

- 创建数据库（不创建使用系统默认）

-(BOOL) initRealm {

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

# 二、一对一

// Model

@interface PersonModel : RLMObject
    
@property NSString *name;
@property int age;
@property int personId;

@end

RLM_ARRAY_TYPE(PersonModel);

- 增

-(void) insertData {

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

- 删

-(void) deletedData {

    PersonModel *person = _allPersons[0];
    [_realm transactionWithBlock:^{
    
        [_realm deleteObject:person];
    }];
    
}

- 改

-(void) updateData {

    PersonModel *person = _allPersons[0];
    [_realm transactionWithBlock:^{
    
        person.name = @"测试";
    }];
    
}

- 查

-(void) seletedData {

    // 条件查询
    
//    NSString *filter = [NSString stringWithFormat:@"age > %d", 100];
//    _allPersons = [PersonModel objectsInRealm:_realm where:filter];

    _allPersons = [PersonModel allObjects];
    NSLog(@"%@",_allPersons);
    
}


# 三、一对多

// Model  userId为主建

@interface UserMessageMD : RLMObject

@property NSString *title;
@property NSString *messageId; // 主键
@property NSString *subTitle;

@end
RLM_ARRAY_TYPE(UserMessageMD);


@interface UserMD : RLMObject

@property NSString *userId; // 主键
@property RLMArray <UserMessageMD>* userMessages;

@end
RLM_ARRAY_TYPE(UserMD);


- 创建表

-(void) createTable {

    
    UserMD *userMD;
    NSString *userId = @"200";
    // 查询当前是否有这个表
    if ([UserMD objectInRealm:_realm forPrimaryKey:userId]) {
        userMD = [UserMD objectInRealm:_realm forPrimaryKey:userId];
        
    }else {
        userMD = [UserMD new];
        userMD.userId = userId;
    }
    
    UserMessageMD *userMessageMD;
    NSString *messageId = @"20000";
    __block BOOL isHaveMessage = NO;
    if([UserMessageMD objectInRealm:_realm forPrimaryKey:messageId]) {
        // 如果有则是更新
        userMessageMD = [UserMessageMD objectInRealm:_realm forPrimaryKey:messageId];
        isHaveMessage = YES;
    
    }else {
        // 插入新的数据
        userMessageMD = [UserMessageMD new];
        userMessageMD.title = @"我是主标题";
        userMessageMD.subTitle = @"我是副标题";
        userMessageMD.messageId = messageId;
    }

    
    [_realm transactionWithBlock:^{
        if (! isHaveMessage) { // 追加
            [userMD.userMessages addObject:userMessageMD];
            isHaveMessage = NO;
        }else { // 更新操作
            userMessageMD.title = @"我是测试标题";
            userMessageMD.subTitle = @"我是测试子标题";
        }
        [_realm addOrUpdateObject:userMD];
    }];
}

- 查询

-(void) queryDatas {

    NSLog(@"%@",[UserMD allObjectsInRealm:_realm]);
}

