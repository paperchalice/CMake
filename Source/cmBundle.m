#include <Foundation/NSBundle.h>
#include <UniformTypeIdentifiers/UTCoreTypes.h>

int preferGuiMacOS(void) {
  NSBundle *bundle = [NSBundle mainBundle];
  if (!bundle)
    return 1;
  UTType *ty = nil;
  [bundle.bundleURL getResourceValue: &ty forKey: NSURLContentTypeKey error: nil];
  return ty == UTTypeBundle;
}
