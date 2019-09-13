#import "StripePaymentPlugin.h"
#import <Stripe/Stripe.h>

@implementation StripePaymentPlugin {
    FlutterResult flutterResult;
    NSString* merchantIdentifier;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"stripe_payment" binaryMessenger:[registrar messenger]];
    StripePaymentPlugin* instance = [[StripePaymentPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"addSource" isEqualToString:call.method]) {
      [self openStripeCardVC:result];
  }
  else if ([@"setPublishableKey" isEqualToString:call.method]) {
      [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:call.arguments];
  }
  else if ([@"setMerchantIdentifier" isEqualToString:call.method]) {
       merchantIdentifier = call.arguments;
      [[STPPaymentConfiguration sharedConfiguration] setAppleMerchantIdentifier:merchantIdentifier];
  }
  else if ([@"useApplePay" isEqualToString:call.method]) {
      [self openNativePay:result];
  } else if ([@"nativePay" isEqualToString:call.method]) {
      [self openNativePay:result];
  }
  else {
      result(FlutterMethodNotImplemented);
  }
}

-(void)openNativePay:(FlutterResult) result {
    printf("start native pay");
    flutterResult = result;
    PKPaymentRequest *paymentRequest = [Stripe paymentRequestWithMerchantIdentifier:merchantIdentifier country:@"US" currency:@"USD"];
    paymentRequest.paymentSummaryItems = @[
                                               [PKPaymentSummaryItem summaryItemWithLabel:@"Fancy Hat" amount:[NSDecimalNumber decimalNumberWithString:@"1.20"]],
                                               // The final line should represent your company;
                                               // it'll be prepended with the word "Pay" (i.e. "Pay iHats, Inc $50")
                                               [PKPaymentSummaryItem summaryItemWithLabel:@"iHats, Inc" amount:[NSDecimalNumber decimalNumberWithString:@"1.00"]],
                                               ];

    if ([Stripe canSubmitPaymentRequest:paymentRequest]) {
        PKPaymentAuthorizationViewController *paymentAuthorizationViewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
        paymentAuthorizationViewController.delegate = self;
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:paymentAuthorizationViewController animated:YES completion:nil];
    }
        else {
        printf("Apple-Pay config is sorta broke.");
    }
}

-(void)openStripeCardVC:(FlutterResult) result {
    flutterResult = result;

    STPAddSourceViewController* addSourceVC = [[STPAddSourceViewController alloc] init];
    addSourceVC.srcDelegate = self;
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:addSourceVC];
    [navigationController setModalPresentationStyle:UIModalPresentationFormSheet];

    UIViewController* controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [controller presentViewController:navigationController animated:true completion:nil];
}

- (void)addCardViewControllerDidCancel:(STPAddSourceViewController *)addCardViewController {
    [addCardViewController dismissViewControllerAnimated:true completion:nil];
}

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment handler:(void (^)(PKPaymentAuthorizationResult * _Nonnull))completion {
    printf("apple pay token => %@", payment.token);
    PKPaymentAuthorizationResult* success = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil];
    completion(success);
}

-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:true completion:nil];
}


- (void)addCardViewController:(STPAddSourceViewController *)addCardViewController
              didCreatePaymentMethod:(nonnull STPPaymentMethod *)paymentMethod
                   completion:(nonnull STPErrorBlock)completion {
    flutterResult(paymentMethod.stripeId);
    
    [addCardViewController dismissViewControllerAnimated:true completion:nil];
}

@end
