// Generated by class-dump 3.5 (64 bit), with modification

NS_ASSUME_NONNULL_BEGIN

@interface PKSignedContainer : NSObject

- (nullable instancetype)initForReadingFromContainerAtURL:(NSURL *)url
                                                    error:(NSError **)error;

- (void)startUnarchivingAtPath:(NSString *)path
                 notifyOnQueue:(dispatch_queue_t)queue
                      progress:(void (^)(double, NSString *))progressBlock
                        finish:(void (^)(BOOL))finishBlock;

@end

NS_ASSUME_NONNULL_END
