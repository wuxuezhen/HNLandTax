//
//  JMPageNetModel.m
//  AZURestWeidu3
//
//  Created by 吴振振 on 2017/12/29.
//  Copyright © 2017年 coreface. All rights reserved.
//

#import "JMPageNetModel.h"
#import "JMAPI.h"

@interface JMPageNetModel()
@property (nonatomic, readwrite) NSInteger currentPage;
@property (nonatomic, readwrite) NSInteger totalPage;
@property (nonatomic, readwrite) NSInteger totalCount;
@property (nonatomic, readwrite) BOOL allDownloaded;
@property (nonatomic, readwrite) BOOL networkFailed;
@property (nonatomic, readwrite, getter=isLoading) BOOL loading;
@property (strong, nonatomic) NSURLSessionDataTask *currentDataTask;

@property (strong, nonatomic) Class klass;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *key;
@property (copy, nonatomic) NSDictionary *params;
@property (copy, nonatomic) void (^refreshCompletionBlock)(void);
@end

@implementation JMPageNetModel

- (instancetype)initWithJSONModelClass:(Class)klass key:(NSString *)key apiPath:(NSString *)path{
    if (self = [super init]) {
        _currentPage = 1;
        _klass = klass;
        _path = path;
        _key = key;
    }
    return self;
}

- (instancetype)initWithJSONModelClass:(Class)klass key:(NSString *)key apiPath:(NSString *)path params:(NSDictionary *)params {
    if (self = [self initWithJSONModelClass:klass key:key apiPath:path]) {
        _params = [params copy];
    }
    return self;
}

- (void)getFirstPage {
    self.RefreshHandler ? self.RefreshHandler() : nil;
    [self refreshState];
    [self getNextPage];
}

- (void)getNextPage {
    if (self.isLoading || self.allDownloaded) {
        if (self.allDownloaded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.AllDownloadedHandler ? self.AllDownloadedHandler() : nil;
            });
        }
        return ;
    }
    
    self.loading = YES;
    NSMutableDictionary *params = [@{
                                     @"pageNum" : @(self.currentPage),
                                     @"pageSize" : @20
                                     } mutableCopy];
    if (self.params) {
        [params addEntriesFromDictionary:self.params];
    }
    
    __weak typeof(self) wself = self;
    self.currentDataTask = [JMAPI GET:self.path params:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(self) strongSelf = wself;
        if (!strongSelf) {
            return ;
        }
        strongSelf.loading = NO;
        NSArray *results = [JMAPI parseIntoArrayOfClass:self.klass fromArray:responseObject[self.key ? : @"result"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.refreshCompletionBlock) {
                self.refreshCompletionBlock();
            }
            if (self.AllTotalCount) {
                self.AllTotalCount(self.totalCount);
            }
            self.refreshCompletionBlock = nil;
        });
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.NextPageHandler ? strongSelf.NextPageHandler(results) : nil;
        });
        
        if (strongSelf.currentPage == strongSelf.totalPage || results.count < 20) {
            strongSelf.allDownloaded = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.AllDownloadedHandler ? strongSelf.AllDownloadedHandler() : nil;
            });
        } else {
            strongSelf.currentPage++;
        }
    } failure:^(NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = wself;
        if (!strongSelf) {
            return ;
        }
        strongSelf.loading = NO;
        strongSelf.allDownloaded = YES;
        strongSelf.networkFailed = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.ErrorHandler ? strongSelf.ErrorHandler(error) : nil;
            
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.refreshCompletionBlock) {
                self.refreshCompletionBlock();
            }
            self.refreshCompletionBlock = nil;
        });
    }];
}

- (void)getNextPage:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure {
    if (self.isLoading || self.allDownloaded) {
        return ;
    }
    
    self.loading = YES;
    NSDictionary *params = @{
                             @"pageNum" : @(self.currentPage),
                             @"pageSize" : @20
                             };
    
    
    self.currentDataTask = [JMAPI GET:self.path params:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loading = NO;
        self.currentPage++;
        NSArray *results = [JMAPI parseIntoArrayOfClass:self.klass fromArray:responseObject[self.key ? : @"result"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(results);
        });
        
        if (self.currentPage == self.totalPage || results.count < 20) {
            self.allDownloaded = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.AllDownloadedHandler ? self.AllDownloadedHandler() : nil;
            });
        }
    } failure:^(NSError * _Nonnull error) {
        self.loading = NO;
        self.allDownloaded = YES;
        self.networkFailed = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.NetworkingErrorHandler ? self.NetworkingErrorHandler() : nil;
        });
    }];
}

- (void)refreshState {
    self.allDownloaded = NO;
    self.loading = NO;
    self.currentPage = 1;
    [self cancelCurrentTask];
}

- (void)refreshParams:(NSDictionary *)params {
    self.params = params;
    [self cancelCurrentTask];
    [self getFirstPage];
}

- (void)refreshParams:(NSDictionary *)params withCompletion:(void (^)(void))completion {
    self.refreshCompletionBlock = [completion copy];
    [self refreshParams:params];
}

- (void)cancelCurrentTask {
    if (self.currentDataTask  && self.currentDataTask.state == NSURLSessionTaskStateRunning) {
        [self.currentDataTask cancel];
    }
    self.currentDataTask = nil;
}
@end
