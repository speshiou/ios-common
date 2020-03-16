#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @enum GANSearchAdType
 * The types of ads that are supported by the ad controller.
 */
typedef NS_ENUM(NSInteger, GANSearchAdType) {
  // Text ad.
  GANSearchAdTypeText = 0,
  // Fill pla ads for a certain height/width. For skipjack, the number of ads
  // will always be set to 1 and the height and width are not set.
  GANSearchAdTypePLANPack = 1,
  // Request a single PLA ad.
  GANSearchAdTypePLASingle = 2,
  // Sponsored product ad.
  GANSearchAdTypeSPA = 4
};

extern const NSInteger GANDefaultMaxAds;

/** Enables clients to customize the ad controller. */
@interface GANSearchAdControllerOptions : NSObject<NSCopying>

/**
 * Controls the behavior of the GANSearchAdController when available ads are running low. If true
 * and if the number of available ads (ads that have loaded) is running low, the
 * GANSearchAdController will automatically request additional ads to the server.
 *
 * <p>Defaults to @c NO.
 */
@property(nonatomic, readwrite, assign, getter=isPrefetchEnabled)
    BOOL prefetchEnabled;

/**
 * The number of ads to retrieve at a time.
 *
 * <p>Defaults to @c GANDefaultMaxAds .
 */
@property(nonatomic, readwrite, assign) NSInteger adFetchCount;

/**
 * The type of ads to request.
 *
 * <p>See @c GANSearchAdType for options. Defaults to @c GANSearchAdTypeText
 */
@property(nonatomic, readwrite, assign) GANSearchAdType adType;

/**
 * An arbitrary string that can be used to tag groups of requests so they can be
 * recognized in a log file and then analyzed.
 */
@property(nullable, nonatomic, readwrite, copy) NSString *channel;

/**
 * Specifies the filtering rules that Google should apply to ads matching the search query
 * (optional).
 *
 * <p>The following are the valid settings for adsafe and the effect each value has on returned
 * ads:
 *
 * <p>"high" Returns family-safe ads. Does not return non-family-safe or adult sexual content
 * ads.
 *
 * <p>"medium" Returns family-safe and non-family-safe ads. Does not return adult sexual content
 * ads.
 *
 * <p>"low" Returns all types of ads.
 *
 * <p>Defaults to high.
 */
@property(nullable, nonatomic, readwrite, copy) NSString *adSafe;

/**
 * Sets whether the request for ads is a test (optional).
 *
 * <p>When @c adTest is true, Google treats the request as a test and does not count the ad
 * impressions or track the clickthrough results. Set this option when testing, but not in
 * production systems or you will not be paid for ads that you display.
 *
 * <p>Defaults to NO.
 */
@property(nonatomic, readwrite) BOOL adTest;

/**
 * Sets whether personalized ads should be delivered for the user.
 *
 * The option will only be sent as part of the request if the value is set. Once the value is set
 * it cannot be unset.
 *
 * <p>Defaults to unset
 */
@property(nonatomic, readwrite) BOOL personalizedAds;

@end

NS_ASSUME_NONNULL_END
