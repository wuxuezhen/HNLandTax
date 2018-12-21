//
//  WZVideo.m
//  HNLandTax
//
//  Created by wzz on 2018/11/22.
//  Copyright © 2018 WYW. All rights reserved.
//

#import "WZVideo.h"

@implementation WZVideo

-(NSURL *)playURL{
    if (self.isDownload) {
        return [NSURL fileURLWithPath:self.localPath];
    }else{
        return [NSURL URLWithString:self.videoUrl];
    }
}

-(NSString *)key{
    return self.videoUrl.lastPathComponent;
}

-(NSString *)localPath{
    if (self.isDownload) {
        return [self localPathForKey:self.key];
    }else{
        return nil;
    }
}

-(BOOL)isDownload{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.key];
}

-(NSString *)localPathForKey:(NSString *)key{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:key];
}

-(void)wz_removeObjectForKey{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.localPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.localPath error:nil];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:self.key]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.key];
    }
    
    self.isDownload = NO;
}
@end
