//  Created by Darius on 27/10/16.

#import <Foundation/Foundation.h>

@class CCSource;

@interface CCSection : NSObject

+ (instancetype)section;

// Setters

- (CCSource*)appendCell:(Class)cellClass params:(NSMutableDictionary**)params;

- (CCSource*)setHeader:(Class)headerCalss params:(NSMutableDictionary**)params;

- (CCSource*)setFooter:(Class)footerClass params:(NSMutableDictionary**)params;


- (CCSource*)insertCell:(Class)cellClass params:(NSMutableDictionary**)params atIndex:(NSInteger)index;

// Getters

- (NSUInteger)count;

- (NSMutableArray <CCSource *> *)sources;

- (CCSource*)sourceAtIndex:(NSUInteger)index;

- (CCSource*)sourceForHeader;

- (CCSource*)sourceForFooter;

// Removers

- (void)dropLastSource;

@end
