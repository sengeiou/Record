#import "UIViewController+MethodSwizzlingForPanBack.h"
#import <objc/runtime.h>

@implementation UIViewController (MethodSwizzlingForPanBack)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method ovr_method = class_getInstanceMethod([self class], @selector(viewDidAppear:));
        Method swz_method = class_getInstanceMethod([self class], @selector(swizzlingForPanBack_viewDidAppear:));
        method_exchangeImplementations(ovr_method, swz_method);
    });
}

- (void)swizzlingForPanBack_viewDidAppear:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self swizzlingForPanBack_viewDidAppear:animated];
}


@end
