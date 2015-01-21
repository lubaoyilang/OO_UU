//
//  ParametersManagerObject.m
//  UThing
//
//  Created by luyuda on 14/11/24.
//  Copyright (c) 2014年 UThing. All rights reserved.
//

#import "ParametersManagerObject.h"
#import "UthingMD5Util.h"
#import "CommonFunc.h"

@interface ParametersManagerObject ()

@property (nonatomic,strong)NSMutableArray *array;

@end

@implementation ParametersManagerObject

- (id)init
{
    self = [super init];
    
    if (self) {
        _array = [[NSMutableArray alloc] init];
    }

    return self;
}

- (NSString*)passwordEncrypt:(NSString*)pwd
{
    
    NSString *key = @"uthinghx436x73bottoxfqxvxlsjfzgr";
    NSString *desStr = @"";
    for (int i = 0; i<[pwd length]; i+=[key length]) {
        
        NSString *temp = [pwd substringFromIndex:i];
        
        NSData *data = [temp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *ok = [CommonFunc obfuscate:data withKey:key];
        desStr = [NSString stringWithFormat:@"%@%@",desStr,ok];
    }
    
    NSString *doook = [CommonFunc base64StringFromText:desStr];
    return doook;
    

}

- (void)removeObjects
{
    [_array removeAllObjects];
}

- (void)addParamer:(NSObject*)objct
{
    [_array addObject:objct];

}
- (NSString*)getSign
{
    
    
    NSString *Keystr = [self getParamers];
    
//    if ([Keystr length]) {
//        Keystr = [NSString stringWithFormat:@"%@uthinghx436x73bottoxfqxvxlsjfzgr",Keystr];
//    }else{
//        return nil;
//    }
    
    Keystr = [NSString stringWithFormat:@"%@uthinghx436x73bottoxfqxvxlsjfzgr",Keystr];

    NSString *sg = [UthingMD5Util getmd5WithString:Keystr];

    return sg;

}
- (NSString*)getParamers
{
    
    [_array sortUsingSelector:@selector(compare:)];
    
    NSString *Keystr = @"";
    
    for (int i = 0;i<[_array count];i++ ) {
        NSString *str = [_array objectAtIndex:i];
        if (i == 0) {
            Keystr = [NSString stringWithFormat:@"%@",str];
        }else{
            Keystr = [NSString stringWithFormat:@"%@&%@",Keystr,str];
        }
        
    }
    
    return Keystr;
    
}


- (NSString*)getParamersWithSign
{
    NSString *pars = [self getParamers];
    
    NSString *sign = [self getSign];
    
    
    NSString *str = [NSString stringWithFormat:@"%@&sign=%@",pars,sign];
    NSLog(@"参数为 %@",str);
    return str;

    
}

- (NSData*)getAddParamer:(NSArray*)pArr
{
    NSString *pars = [self getParamersWithSign];
    
    for (NSString *str in pArr) {
        if (![str length]) {
            continue;
        }
        pars  = [NSString stringWithFormat:@"%@&%@",pars,str];
    }
    
    //NSString *str = [NSString stringWithFormat:@"%@&%@",pars,p];
    NSData *param = [pars dataUsingEncoding:NSUTF8StringEncoding
                                             allowLossyConversion:YES];
    
    return param;
    
}


- (NSData*)getHeetBody
{
    NSData *param = [[self getParamersWithSign] dataUsingEncoding:NSUTF8StringEncoding
                                                allowLossyConversion:YES];
    
    return param;
}

- (NSString*)dictToString:(NSDictionary*)dict
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *arr = [dict allKeys];
    
    for (int i = 0; i<[arr count]; i++) {
        
        NSString *key = [arr objectAtIndex:i];
        id obj = [dict objectForKey:key];
        
        if ([obj isKindOfClass:[NSString class]]) {
            if ([obj length]) {
                
                if ([key isEqualToString:@"sign_type"] || [key isEqualToString:@"sign"] ||[key isEqualToString:@"action"] ||[key isEqualToString:@"_request"] || [key isEqualToString:@"authcode"]) {
                    continue;
                }else{
                    [array addObject:[NSString stringWithFormat:@"%@=%@",[arr objectAtIndex:i],obj]];
                }
                
                
            }
            
            
        }else if ([obj isKindOfClass:[NSNumber class]]){
            [array addObject:[NSString stringWithFormat:@"%@=%@",[arr objectAtIndex:i],obj]];
            
        }else if ([obj isKindOfClass:[NSArray class]]){
            NSString *str = [self arrayToString:obj];
            [array addObject:[NSString stringWithFormat:@"%@=%@",[arr objectAtIndex:i],str]];
            
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            NSString *str = [self dictToString:obj];
            [array addObject:[NSString stringWithFormat:@"%@=%@",[arr objectAtIndex:i],str]];
            
        }
        
        
        
    }
    
    if ([array count]) {
        [array sortUsingSelector:@selector(compare:)];
    }
    
    
    NSString *Keystr = @"";
    
    for (int i = 0;i<[array count];i++ ) {
        NSString *str = [array objectAtIndex:i];
        if (i == 0) {
            Keystr = [NSString stringWithFormat:@"%@",str];
        }else{
            Keystr = [NSString stringWithFormat:@"%@&%@",Keystr,str];
        }
        
        
    }
    return Keystr;
    
    
    

}



- (NSString*)arrayToString:(NSArray*)arr
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0;i<[arr count];i++) {
        id obj = [arr objectAtIndex:i];
        if ([obj isKindOfClass:[NSString class]]) {
            if ([obj length]) {
                [array addObject:[NSString stringWithFormat:@"%d=%@",i,obj]];
            }

        }else if ([obj isKindOfClass:[NSNumber class]]){
            [array addObject:[NSString stringWithFormat:@"%@=%@",[arr objectAtIndex:i],obj]];
            
        }else if ([obj isKindOfClass:[NSArray class]]){
            NSString *str = [self arrayToString:obj];
            [array addObject:[NSString stringWithFormat:@"%d=%@",i,str]];
        
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            NSString *str = [self dictToString:obj];
            [array addObject:[NSString stringWithFormat:@"%d=%@",i,str]];
        
        }
        
        
    }
    
    
    
//    if ([array count]) {
//        [array sortUsingSelector:@selector(compare:)];
//    }
    
    
    NSString *Keystr = @"";
    
    for (int i = 0;i<[array count];i++ ) {
        NSString *str = [array objectAtIndex:i];
        if (i == 0) {
            Keystr = [NSString stringWithFormat:@"%@",str];
        }else{
            Keystr = [NSString stringWithFormat:@"%@&%@",Keystr,str];
        }
        
        
    }
    
    return Keystr;
    
    
    
    
    
}


- (BOOL)checkSign:(id)data Sign:(NSString*)sg
{
    
    //////创建一个存储参数的数组
    NSMutableArray *array = [[NSMutableArray alloc] init];
    

    
    if ([data isKindOfClass:[NSDictionary class]]) {
        
        ////遍历data里边的每一个key value
        NSArray *keyArr = [data allKeys];
        for (int i = 0;i<[keyArr count];i++ ) {
            NSString *key = [keyArr objectAtIndex:i];
            id obj = [data objectForKey:key];
            
            if ([obj isKindOfClass:[NSString class]]) {
                if ([obj length]) {
                    if ([key isEqualToString:@"sign_type"] || [key isEqualToString:@"sign"] ||[key isEqualToString:@"action"] ||[key isEqualToString:@"_request"] ||[key isEqualToString:@"authcode"]) {
                        continue;
                    }else{
                        [array addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
                    }
                    
                }
                
                
            }else if ([obj isKindOfClass:[NSArray class]]){
                NSString *str = [self arrayToString:obj];
                [array addObject:[NSString stringWithFormat:@"%@=%@",key,str]];
                
            }else if ([obj isKindOfClass:[NSDictionary class]]){
                NSString *str = [self dictToString:obj];
                [array addObject:[NSString stringWithFormat:@"%@=%@",key,str]];
                
            }else if ([obj isKindOfClass:[NSNumber class]]){
                
                [array addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
            }
            
            
            
        }
        
        
        
        
        NSLog(@"arr count = %d",[array count]);
        if ([array count]) {
            [array sortUsingSelector:@selector(compare:)];
        }
        
        
        NSString *Keystr = @"";
        
        for (int i = 0;i<[array count];i++ ) {
            NSString *str = [array objectAtIndex:i];
            if (i == 0) {
                Keystr = [NSString stringWithFormat:@"%@",str];
            }else{
                Keystr = [NSString stringWithFormat:@"%@&%@",Keystr,str];
            }
            
            
        }
        
        
        
        if ([Keystr length]) {
            Keystr = [NSString stringWithFormat:@"%@uthinghx436x73bottoxfqxvxlsjfzgr",Keystr];
        }
        
        
        NSString *sgg = [UthingMD5Util getmd5WithString:Keystr];
        
        if ([sg isEqualToString:sgg]) {
            return YES;
        }else{
            return NO;
        }
        
        
        
        
        
    }else if ([data isKindOfClass:[NSArray class]]){
    
        
        
        ////遍历data里边的每一个key value
        for (int i = 0;i<[data count];i++ ) {
            id obj = [data objectAtIndex:i];
            
            if ([obj isKindOfClass:[NSString class]]) {
                if ([obj length]) {
                    [array addObject:[NSString stringWithFormat:@"%d=%@",i,obj]];
                }
                
                
            }else if ([obj isKindOfClass:[NSArray class]]){
                NSString *str = [self arrayToString:obj];
                [array addObject:[NSString stringWithFormat:@"%d=%@",i,str]];
                
            }else if ([obj isKindOfClass:[NSDictionary class]]){
                NSString *str = [self dictToString:obj];
                [array addObject:[NSString stringWithFormat:@"%d=%@",i,str]];
                
            }else if ([obj isKindOfClass:[NSNumber class]]){
                
                [array addObject:[NSString stringWithFormat:@"%d=%@",i,obj]];
            }
            
            
            
        }
        
     
        
        
        
//        NSLog(@"arr count = %d",[array count]);
//        if ([array count]) {
//            [array sortUsingSelector:@selector(compare:)];
//        }
        
        
        NSString *Keystr = @"";
        
        for (int i = 0;i<[array count];i++ ) {
            NSString *str = [array objectAtIndex:i];
            if (i == 0) {
                Keystr = [NSString stringWithFormat:@"%@",str];
            }else{
                Keystr = [NSString stringWithFormat:@"%@&%@",Keystr,str];
            }
            
            
        }
        
        
        
        //if ([Keystr length]) {
            Keystr = [NSString stringWithFormat:@"%@uthinghx436x73bottoxfqxvxlsjfzgr",Keystr];
        //}
        
        
        NSString *sgg = [UthingMD5Util getmd5WithString:Keystr];
        
        if ([sg isEqualToString:sgg]) {
            return YES;
        }else{
            return NO;
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }

    return YES;
    

}




@end
