#import "QrCodePlugin.h"
#import <qr_code/qr_code-Swift.h>

@implementation QrCodePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftQrCodePlugin registerWithRegistrar:registrar];
}
@end
