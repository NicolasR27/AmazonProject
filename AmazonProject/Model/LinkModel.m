//
//  LinkModel.m
//  AmazonProject
//
//  Created by Nicolas Rios on 10/2/24.
//

#import "LinkModel.h"

@implementation LinkModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _linkURLs = @{
            @"46530": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202063460",
            @"Whole Foods": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202111220",
            @"Medical Care": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202166830",
            @"Pharmacy": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202033900",
            @"Grocery": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202112510",
            @"Electronics": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202112420",
            @"Books": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202056920"
        };
    }
    return self;
}

- (NSString *)getURLForTitle:(NSString *)title {
    return [self.linkURLs objectForKey:title];
}

@end
