#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GANSearchAdControllerOptions;
@class GANSearchAdRequest;
@class GANAdView;

@protocol GANSearchAdControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 * @enum GANExperimentVariantStatus
 * The experiment status of the served style.
 */
typedef NS_ENUM(NSInteger, GANExperimentVariantStatus) {
  // The served style was not selected for an experiment.
  GANNotSelectedForExperiment = 0,

  // The served style is an experiment variant.
  GANExperimentVariant = 1,

  // The served style is an experiment control.
  GANExperimentControl = 2
};

/**
 * Retrieves search ads and makes them available to the client of the SDK.
 */
@interface GANSearchAdController : NSObject

/** The publisher id used for ad requests. */
@property(nonatomic, readonly, copy) NSString *publisherID;

/** The settings id used for ad requests. */
@property(nonatomic, readonly, copy) NSString *styleID;

/** The options used for all ad requests. */
@property(nonatomic, readonly, strong) GANSearchAdControllerOptions *options;

/**
 * Whether the most recently served style is an experiment variant, an experiment control, or was
 * not selected for an experiment.
 */
@property(nonatomic, readonly) GANExperimentVariantStatus experimentVariantStatus;

- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes the ad controller.
 * @param publisherID The publisher id, e.g. "ms-app-pub-9616389000213823".
 * @param styleID The settings id for the template that will be used to render native ads.
 * @param options GANSearchAdControllerOptions, such as whether to prefetch ads, adTest, adSafe,
                  etc.
 * @param delegate GANSearchAdControllerDelegate for receiving notifications when ads are loaded
 *                 and other events.
 */
- (instancetype)initWithPublisherID:(NSString *)publisherID
                            styleID:(NSString *)styleID
                            options:(nullable GANSearchAdControllerOptions *)options
                           delegate:(nullable id<GANSearchAdControllerDelegate>)delegate;

/**
 * Retrieves, asynchronously, the first page of ads for the given @c adRequest, and subsequent pages
 * as needed.
 * This method should be called only once per request: if the option @c prefetchEnabled is @c YES,
 * subsequent pages will be retrieved automatically.
 * When new ads are loaded (or fail to load) the @c GANSearchAdControllerDelegate will be called on
 * the main thread.
 * @param adRequest The GANSearchAdRequest query.
 */
- (void)loadAds:(GANSearchAdRequest *)adRequest;

/**
 * Retrieves, asynchronously the next page of ads for the previous request specified by the last
 * call to @c loadAds:.
 * If @c loadAds: has not been called, this will return an error through the @c
 * GANSearchAdControllerDelegate.
 * If there is a full page of ads that have not been shown, this will also return an error to the
 * delegate.
 */
- (void)loadMoreAds;

/**
 * Returns the total number of ads loaded from the most recent call to @c loadAds:.
 */
- (NSInteger)adCount;

/**
 * Create an empty adView
 */
- (GANAdView *)adView;

/**
 * Populate an adView with the ad specified by the identifier
 *  - if @c adIdentifier is a new identifier, the view will show the next available ad.
 *  - if @c adIdentifier has already been used, the view will show the same ad it showed the first
 *    time this method was called with @c adIdentifier.
 * @param view The GANAdView to populate.
 * @param adIdentifier An ad identifier used to identify this ad. This can be any NSString. Each
 *                     unique string will be assigned to the next available ad until ads are
 *                     exhausted.
 */
- (void)populateAdView:(GANAdView *)view identifier:(NSString *)adIdentifier;

@end

NS_ASSUME_NONNULL_END
