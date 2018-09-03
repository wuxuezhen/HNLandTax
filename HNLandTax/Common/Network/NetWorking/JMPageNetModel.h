//
//  JMPageNetModel.h
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/29.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPConstants.h"
@interface JMPageNetModel : NSObject
@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, readonly) NSInteger totalPage;
@property (nonatomic, readonly) BOOL allDownloaded;
@property (nonatomic, readonly) BOOL networkFailed;
@property (nonatomic, readonly, getter=isLoading) BOOL loading;

@property (nonatomic, copy) void (^AllDownloadedHandler)(void);
@property (nonatomic, copy) void (^NetworkingErrorHandler)(void);
@property (nonatomic, copy) void (^NextPageHandler)(NSArray *results);
@property (nonatomic, copy) void (^ErrorHandler)(NSError *error);
@property (nonatomic, copy) void (^RefreshHandler)(void);
@property (nonatomic, copy) void (^AllTotalCount)(NSInteger total);

- (void)getNextPage;
- (void)getFirstPage;
- (void)refreshParams:(NSDictionary *)params;
- (void)refreshParams:(NSDictionary *)params withCompletion:(void (^)(void))completion;

- (instancetype)initWithJSONModelClass:(Class)klass key:(NSString *)key apiPath:(NSString *)path;
- (instancetype)initWithJSONModelClass:(Class)klass key:(NSString *)key apiPath:(NSString *)path params:(NSDictionary *)params;
@end
