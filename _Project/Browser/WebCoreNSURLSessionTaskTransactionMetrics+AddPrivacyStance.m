//
//  WebCoreNSURLSessionTaskTransactionMetrics+AddPrivacyStance.m
//  Browser
//
//  Created by Povilas Staskus on 2023-01-18.
//  Copyright © 2023 High Caffeine Content. All rights reserved.
//

// A workaround fix for a crash happening at runtime
// WebCoreNSURLSessionTaskTransactionMetrics is expected to have _privacyStance although it does not exist
// https://github.com/jvanakker/tvOSBrowser/issues/54

#import <objc/runtime.h>
#import <Foundation/Foundation.h>


int privacyStanceGetter(id self, SEL _cmd) {
    return 0;
}

@implementation NSObject (WebCoreNSURLSessionTaskTransactionMetrics)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("WebCoreNSURLSessionTaskTransactionMetrics");
        
        /// Do not attempt to add privacyStance if it already exists
        if (class_getInstanceMethod(class, NSSelectorFromString(@"_privacyStance")) != nil) {
            return;
        }
        
        objc_property_attribute_t attrs[] = { };
        class_addProperty(class, "privacyStance", attrs, 0);
        class_addMethod(class, NSSelectorFromString(@"_privacyStance"), (IMP)privacyStanceGetter, "@@:");
    });
}

@end
