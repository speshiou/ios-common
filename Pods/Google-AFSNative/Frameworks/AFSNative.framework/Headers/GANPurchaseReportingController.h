#import <Foundation/Foundation.h>

@class GANItemInfo;

/** Provides an API for the partner to report purchases from their app. */
@interface GANPurchaseReportingController : NSObject

/** The Merchant Center ID for the client app. */
@property(nonatomic, readonly, copy) NSString *merchantID;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMerchantID:(NSString *)merchantID;

/**
 * Reports purchases of items from the app. The orderID should be unique within a given
 * partner's purchases to prevent duplicate conversions from being reported.
 * @param items A list of items that were purchased.
 * @param orderID A unique identifier to identify the order.
 */
- (void)reportPurchaseOfItems:(NSArray<GANItemInfo *> *)items
                      orderID:(NSString *)orderID;
@end
