//
//  PersonModel.h
//  RealmLearn
//
//  Created by MAC on 2016/12/12.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <Realm/Realm.h>

@interface PersonModel : RLMObject
    
@property NSString *name;
@property int age;
@property int personId;

@end

RLM_ARRAY_TYPE(PersonModel);


