#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Typically, the client of the SDK will instantiate a GANSearchAdRequest with
 * the appropriate query and then it will use to load ads through the
 * GANSearchAdController (-loadAds:).
 */
@interface GANSearchAdRequest : NSObject <NSCopying>

/**
 * The search query, such as "flowers". It must be a non empty string. It should not be
 * URL-encoded.
 */
@property(nonatomic, readwrite, copy) NSString *query;

/**
 * The price currency (as case-insensitive <a
 * href="https://developers.google.com/ad-exchange/seller-rest/appendix/currencies">three-letter
 * ISO currency code</a>) to use for filtering products by price with @c priceMin or @c priceMax
 * (optional).
 *
 * <p>Only valid for Sponsored Product Ads (SPA). Must be specified if @c priceMin or
 * @c priceMax is set. The price filter will not be applied if the provided currency code
 * does not match the currency of the returned ads.
 */
@property(nonatomic, readwrite, copy) NSString *priceCurrency;

/**
 * The minimum product price (in the currency specified with @c priceCurrency) for ads to be
 * returned (optional).
 *
 * <p>Only valid for Sponsored Product Ads (SPA). @c priceCurrency must be set if this
 * option is specified. The price filter will not be applied if the provided currency code does
 * not match the currency of the returned ads.
 *
 * <p>The given price should contain only numeric characters and periods (e.g. "19.95") and must
 * not contain currency symbols (e.g. "$") or commas (",").
 *
 * <p>These values are not sanitized in the SDK. Invalid values may result in request failures.
 */
@property(nonatomic, readwrite, copy) NSString *priceMin;

/**
 * The maximum product price (in the currency specified with @c priceCurrency) for ads to
 * be returned (optional).
 *
 * <p>Only valid for Sponsored Product Ads (SPA). @c priceCurrency must be set if this option
 * is specified. The price filter will not be applied if the provided currency code does not match
 * the currency of the returned ads.
 *
 * <p>The given price should contain only numeric characters and periods (e.g. "19.95") and must
 * not contain currency symbols (e.g. "$") or commas (",").
 *
 * <p>These values are not sanitized in the SDK. Invalid values may result in request failures.
 */
@property(nonatomic, readwrite, copy) NSString *priceMax;

/**
 * Filter options for SPA, as a string of `,` separated list of `key:value` pairs (optional).
 *
 * <p>Only valid for Sponsored Product Ads (SPA).
 *
 * <p>These values are not sanitized in the SDK. Invalid values may result in request failures.
 */
@property(nonatomic, readwrite, copy) NSString *spaRestricts;

/**
 * For testing purposes, sets the user's location to return location-targeted shopping ads
 * (optional).
 *
 * <p>Only valid for AdSense for Shopping (AFSh) ads with @c adtest on. Provide the
 * two-letter country code, case-insensitive.
 */
@property(nonatomic, readwrite, copy) NSString *testGeolocation;

/** The target language for the ad request.
 * <p>Languages specified using the Google AdWords API language codes. The
 * default value is 'en'.*/
@property(nonatomic, readwrite, copy) NSString *targetLanguage;

@end

NS_ASSUME_NONNULL_END
