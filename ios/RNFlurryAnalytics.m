#import "RNFlurryAnalytics.h"
#import <Flurry.h>

@implementation RNFlurryAnalytics {
    FlurrySessionBuilder *sessionBuilder;
}

- (instancetype)init {
    self = [super init];
    
    sessionBuilder = [FlurrySessionBuilder new];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    return self;
}

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateFailed: {
                [Flurry logPaymentTransaction:transaction statusCallback:^(FlurryTransactionRecordStatus status) {}];
                break;
            }
            case SKPaymentTransactionStatePurchased: {
                [Flurry logPaymentTransaction:transaction statusCallback:^(FlurryTransactionRecordStatus status) {}];
                break;
            }
            default:
                break;
        }
    }
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(startSession:(NSString *)apiKey)
{
    [Flurry startSession:apiKey withSessionBuilder:sessionBuilder];
}

RCT_EXPORT_METHOD(setAppVersion:(NSString *)version)
{
    [sessionBuilder withAppVersion:version];
}

RCT_EXPORT_METHOD(setDebugLogEnabled:(BOOL)enabled)
{
    [Flurry setLogLevel:enabled ? FlurryLogLevelAll : FlurryLogLevelCriticalOnly];
}

RCT_EXPORT_METHOD(setSessionContinueSeconds:(int)seconds)
{
    [sessionBuilder withSessionContinueSeconds:seconds];
}

RCT_EXPORT_METHOD(setCrashReportingEnabled:(BOOL)enabled)
{
    [sessionBuilder withCrashReporting:enabled];
}

RCT_EXPORT_METHOD(logEvent:(NSString *)eventName timed:(BOOL)timed)
{
    [Flurry logEvent:eventName timed:timed];
}

RCT_EXPORT_METHOD(logEventWithParameters:(NSString *)eventName
                  parameters:(NSDictionary *)parameters
                  timed:(BOOL)timed)
{
    [Flurry logEvent:eventName withParameters:parameters timed:timed];
}

RCT_EXPORT_METHOD(endTimedEvent:(NSString *)eventName
                  parameters:(NSDictionary *)parameters)
{
    [Flurry endTimedEvent:eventName withParameters:parameters];
}

RCT_EXPORT_METHOD(logPageView)
{
    [Flurry logPageView];
}

RCT_EXPORT_METHOD(setUserID:(NSString *)userID)
{
    [Flurry setUserID:userID];
}

RCT_EXPORT_METHOD(setUserAge:(int)age)
{
    [Flurry setAge:age];
}

RCT_EXPORT_METHOD(setUserGender:(NSString *)gender)
{
    [Flurry setGender:gender];
}

@end
