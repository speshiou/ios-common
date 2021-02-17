/**
 * The error domain associated with Google AFSNative if the error is found in
 * the SDK. This does not include errors returned from the server.
 */
extern NSString *const GANErrorDomain;

/**
 * An error code indicating that a @c loadMoreAds request was made before calling loadAds.
 */
extern const NSInteger GANErrorCodeInvalidRequest;

/**
 * An error code indicating that a @c loadMoreAds request was made while the amount
 * of locally cached ads is equal to or larger than the @c adFetchCount.
 */
extern const NSInteger GANErrorCodeTooManyUnusedAds;

/**
 * An error code indicating that a @c loadAds request returned no ads.
 */
extern const NSInteger GANErrorCodeNoFill;

/**
 * A more detailed description of why the error was returned. This is included in the
 * NSError userInfo.
 */
extern NSString *const GANErrorReason;
