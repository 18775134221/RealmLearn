//
//  UserMD.h
//  RealmLearn
//
//  Created by MAC on 2016/12/23.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserMessageMD : RLMObject

@property NSString *title;
@property NSString *messageId; // 主键
@property NSNumber<RLMInt>* subTitle;

@end
RLM_ARRAY_TYPE(UserMessageMD);


@interface UserMD : RLMObject

@property NSString *userId; // 主键
@property RLMArray <UserMessageMD>* userMessages;

@end
RLM_ARRAY_TYPE(UserMD);





