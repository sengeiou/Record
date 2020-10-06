#import "UINavigationController+MethodSwizzlingForPanBack.h"
#import <objc/runtime.h>

@implementation UINavigationController (MethodSwizzlingForPanBack)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method ovr_PushMethod = class_getInstanceMethod([self class], @selector(pushViewController:animated:));
        Method swz_PushMethod = class_getInstanceMethod([self class], @selector(swizzlingForPanBack_pushViewController:animated:));
        method_exchangeImplementations(ovr_PushMethod, swz_PushMethod);
    });
}

- (void)swizzlingForPanBack_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.interactivePopGestureRecognizer.enabled = NO;
    [self swizzlingForPanBack_pushViewController:viewController animated:animated];
}

@end
