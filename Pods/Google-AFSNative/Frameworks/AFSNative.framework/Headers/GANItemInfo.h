#import <Foundation/Foundation.h>

/**
 * An item that was purchased.
 * @deprecated Do not use, supported only for sponsored product ads which have
 * been discontinued.
 */
@interface GANItemInfo : NSObject

@property(nonatomic, readonly, copy) NSString *SKU;
@property(nonatomic, readonly) NSInteger quantity;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithSKU:(NSString *)SKU
                   quantity:(NSInteger)quantity;

@end
