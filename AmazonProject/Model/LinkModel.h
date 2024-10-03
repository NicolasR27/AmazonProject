//
//  LinkModel.h
//  AmazonProject
//
//  Created by Nicolas Rios on 10/2/24.
//

#import <Foundation/Foundation.h>

@interface LinkModel : NSObject

@property (strong, nonatomic) NSDictionary *linkURLs;

- (NSString *)getURLForTitle:(NSString *)title;

@end
