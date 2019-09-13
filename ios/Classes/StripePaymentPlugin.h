#import <Flutter/Flutter.h>
#import "STPAddSourceViewController.h"
#import <PassKit/PassKit.h>

@interface StripePaymentPlugin : NSObject<FlutterPlugin, STPAddPaymentMethodViewControllerDelegate, PKPaymentAuthorizationViewControllerDelegate>

@end
