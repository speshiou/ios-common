#import <Foundation/Foundation.h>

@class GANSearchAdController;

NS_ASSUME_NONNULL_BEGIN

/**
 * A protocol for GANSearchAdController to inform a delegate that new ads have been loaded or that
 * they have failed to load.
 * Typically, the client of the SDK will provide the delegate.
 */
@protocol GANSearchAdControllerDelegate<NSObject>

@optional

/**
 * Notifies the GANSearchAdControllerDelegate that @c numberOfAds new ads have been loaded and are
 * therefore now available. Notes:
 * - this method may be called several times after calling @c loadAds:, if the server has several
 *   pages of ads for a given query.
 * - if there are no additional ads in the server, this method will return 0 for @c numberOfAds
 *   (this is not an error).
 * @param adController The GANSearchAdController that the ads were requested from.
 * @param numberOfAds The number of ads that have been loaded. This is not cumulative.
 */
- (void)searchAdController:(GANSearchAdController *)adController didLoadAds:(NSInteger)numberOfAds;

/**
 * Notifies the GANSearchAdControllerDelegate that ads have failed to load.
 * @param adController The GANSearchAdController that the ads were requested from.
 * @param error The error returned from the ad request.
 */
- (void)searchAdController:(GANSearchAdController *)adController didFailWithError:(NSError *)error;

/**
 * Callback to inform a delegate if url was clicked and the link was opened in a browser.
 */
- (void)externalLinkDidOpen;

/**
 * Handles SPA ad clicks (other than an add-to-cart link in the ad).
 * Required for SPA ads.
 * @param SKU The SKU of the ad that was tapped.
 * @param itemGroupID The itemGroupID of the ad that was tapped.
 */
- (void)spaAdClickedWithSKU:(nullable NSString *)SKU itemGroupID:(nullable NSString *)itemGroupID;

/**
 * Handles add-to-cart link clicks in SPA ads.
 * Required for SPA ads with add to cart link.
 * @param SKU The SKU of the ad that was tapped.
 * @param itemGroupID The itemGroupID of the ad that was tapped.
 */
- (void)spaAddToCartClickedWithSKU:(nullable NSString *)SKU
                       itemGroupID:(nullable NSString *)itemGroupID;
@end

NS_ASSUME_NONNULL_END
