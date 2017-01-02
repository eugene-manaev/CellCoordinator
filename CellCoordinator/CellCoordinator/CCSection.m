//  Created by Darius on 27/10/16.

#import "CCSource.h"
#import "CCSection.h"
#import "CellCoordinator+Internal.h"

@interface CCSection()


@property (nonatomic) CCSource *header;

@property (nonatomic) CCSource *footer;

@property (nonatomic) NSMutableArray <CCSource *> *sources;



@end

@implementation CCSection

+ (instancetype)section {
    
    CCSection *section = [[self alloc] init];
    
    if (section != nil) {
        section.sources = [NSMutableArray array];
    }
    
    
    return section;
}

// Setters

- (CCSource*)appendCell:(Class)cellClass params:(NSMutableDictionary**)params {
    
    CCSource *cellSource = [CCSource sourceWithClass:cellClass params:*params];
    
    [_sources addObject:cellSource];
    
    *params = [NSMutableDictionary dictionary];
    
    return cellSource;
}

- (CCSource*)setHeader:(Class)headerCalss params:(NSMutableDictionary**)params {
    
    CCSource *headerSource = [CCSource sourceWithClass:headerCalss params:*params];
    
    _header = headerSource;
    
    *params = [NSMutableDictionary dictionary];
    
    return headerSource;
}

- (CCSource*)setFooter:(Class)footerClass params:(NSMutableDictionary**)params {
    
    CCSource *footerSource = [CCSource sourceWithClass:footerClass params:*params];
    
    _footer = footerSource;
    
    *params = [NSMutableDictionary dictionary];
    
    return footerSource;
}

- (CCSource*)insertCell:(Class)cellClass params:(NSMutableDictionary**)params atIndex:(NSInteger)index {
    
    CCSource *cellSource = [CCSource sourceWithClass:cellClass params:*params];
    
    [_sources insertObject:cellSource atIndex:index];
    
    *params = [NSMutableDictionary dictionary];
    
    return cellSource;
}

// Getters


- (NSUInteger)count {
    return _sources.count;
}

- (CCSource*)sourceAtIndex:(NSUInteger)index {
    
    if (index < _sources.count) {
        return _sources[index];
    } else {
        return nil;
    }
    
}

- (CCSource*)sourceForHeader {
    
    return _header;
    
}

- (CCSource*)sourceForFooter {
    
    return _footer;
    
}

// Removers

- (void)dropLastSource {
    
    [_sources removeLastObject];
    
}

@end
