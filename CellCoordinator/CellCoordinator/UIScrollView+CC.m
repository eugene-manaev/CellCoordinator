//  Created by Darius on 24/10/16.

#import <objc/runtime.h>

#import "CCSource.h"
#import "CCSection.h"
#import "CCManager.h"
#import "UIView+CC.h"

#import "UIScrollView+CC.h"

static NSString* const kNib = @"nib";

typedef NS_ENUM(NSUInteger, CoordinatorClassKind) {
    CoordinatorClassCell,
    CoordinatorClassHeader,
    CoordinatorClassFooter,
};


@implementation UIScrollView (CellCoordinator)

- (void)ccInitializeWithDelegate:(id)delegate {

    [self buildManagerForDelegate:delegate];
    
}

- (void)ccBuildSection {
    

    NSMutableArray <CCSection *> *sections = [self ccSections];
   
    NSInteger indexOfEditingSection = [self editingSectionIndex];
                                       
    CCSection *targetSection;
    
    if (indexOfEditingSection == -1) {
        targetSection = [sections lastObject];
    } else {
        targetSection = [self ccSectionAtIndex:indexOfEditingSection];
    }
    
    if (targetSection != nil) {
        if ([targetSection count] == 0) {
            return;
        }
    }
    
    CCSection *section = [CCSection section];
    
    if (indexOfEditingSection == -1) {
        [sections addObject:section];
    } else {
        [sections insertObject:section atIndex:indexOfEditingSection];
    }

    
}

- (void)ccInsertSectionAtIndex:(NSInteger)sectionIndex animated:(BOOL)animated prepareSectionBlock:(void (^)())block {
    
    if (block == nil) {
        return;
    }
    
    [self setEditingSectionIndex:sectionIndex];
    
    [self ccBuildSection];
    
    if (block != nil) {
        block();
    }
    
    // Здесь важно удалить section, если ничего не добавилось
    
    NSMutableArray <CCSection *> *sections = [self ccSections];
    
    [self setEditingSectionIndex:-1];
    
    if ([[sections objectAtIndex:sectionIndex] count] == 0) {
        
        [sections removeObjectAtIndex:sectionIndex];
        
        return;
    }

    [self _ccInsertSectionAtIndex:sectionIndex animated:animated];
    
}

- (NSMutableSet <Class> *)ccRegisteredCells {
    
    NSMutableSet *cells = objc_getAssociatedObject(self, _cmd);
    
    if (cells == nil) {
        
        cells = [NSMutableSet set];
        
        objc_setAssociatedObject(self, _cmd, cells, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    return cells;
    
}

- (NSMutableArray <CCSection *> *)ccSections {
    
    NSMutableArray *sources = objc_getAssociatedObject(self, _cmd);
    
    if (sources == nil) {
        
        sources = [NSMutableArray array];
        
        [sources addObject:[CCSection section]];
        
        objc_setAssociatedObject(self, _cmd, sources, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    return sources;
}

- (CCSource *)ccSourceAtIndexPath:(NSIndexPath *)indexPath {
    
    CCSection *section = [self ccSectionAtIndex:indexPath.section];
    
    return [section sourceAtIndex:indexPath.row];
    
}

- (CCSection *)ccSectionAtIndex:(NSUInteger)index {
    
    NSMutableArray <CCSection *> *sections = [self ccSections];
    
    if (index < sections.count) {
        return [sections objectAtIndex:index];
    } else {
        return nil;
    }
    
}


- (CCSource *)ccAppend:(Class)cellClass params:(NSMutableDictionary**)params {
    
    return [self ccAppendClass:cellClass params:params kind:CoordinatorClassCell];
}

- (CCSource *)ccSetHeader:(Class)headerClass params:(NSMutableDictionary**)params {
    
    return [self ccAppendClass:headerClass params:params kind:CoordinatorClassHeader];
}

- (CCSource *)ccSetFooter:(Class)footerClass params:(NSMutableDictionary**)params {
    
    return [self ccAppendClass:footerClass params:params kind:CoordinatorClassFooter];
}

- (void)ccSetSectionIndex:(NSString *)sectionIndexName {
    
    [[[self ccSections] lastObject] setIndexName:sectionIndexName];
}

- (CCSource *)ccAppendClass:(Class)viewClass params:(NSMutableDictionary**)params kind:(CoordinatorClassKind)kind {
    
    [self ccRegisterCellClass:viewClass ofKind:kind];
    
    CCSection *targetSection;
    
    NSInteger indexOfEditingSection = [self editingSectionIndex];
    
    if (indexOfEditingSection == -1) {
        targetSection = [[self ccSections] lastObject];
    } else {
        targetSection = [[self ccSections] objectAtIndex:indexOfEditingSection];
    }
    
    switch (kind) {
        case CoordinatorClassCell:
            return [targetSection appendCell:viewClass params:params];
    
        case CoordinatorClassHeader:
            return [targetSection setHeader:viewClass params:params];
        
        case CoordinatorClassFooter:
            return [targetSection setFooter:viewClass params:params];
            
        default:
            return nil;
    }
    
}

- (CCSource *)ccInsert:(Class)cellClass params:(NSMutableDictionary **)params atIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    
    NSArray <CCSection  *> *sections = self.ccSections;
    
    if (indexPath.section >= sections.count) {
        NSLog(@"CC: Section %li does not exist", (long) indexPath.section);
        return nil;
    }
    
    CCSection *section = sections[indexPath.section];
    
    if (indexPath.row > section.count) {
        NSLog(@"CC: Section %li contains only %lu rows. Cannot insert row at index %li", (long) indexPath.section, (unsigned long) section.count, (long) indexPath.row);
        return nil;
    }
    
    [self ccRegisterCellClass:cellClass ofKind:CoordinatorClassCell];
    
    CCSource *source = [section insertCell:cellClass params:params atIndex:indexPath.row];
    
    [self _ccInsertRowsAtIndexPaths:@[indexPath] animated:animated];
    
    return source;
}

- (NSArray <CCSource *> *)ccDeleteRowsAtIndexPaths:(NSArray <NSIndexPath  *> *)indexPaths animated:(BOOL)animated {
    
    if (indexPaths.count == 0) {    // In case there's nothing to do, return
        return @[];
    }
    
    
    // Sort array, so we can go from the highest indexPaths to the lowest.
    // Example: (3:1), (2:2), (2:0), (1:5), (0:0); where first number is a section and section is a row
    
    NSArray <NSIndexPath  *> *indexPathsToRemove = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *indexPath, NSIndexPath *anotherIndexPath) {
        
        if (indexPath.section != anotherIndexPath.section) {
            return indexPath.section > anotherIndexPath.section ? NSOrderedAscending : NSOrderedDescending;
        }
        
        if (indexPath.row != anotherIndexPath.row) {
            
            return indexPath.row > anotherIndexPath.row ? NSOrderedAscending : NSOrderedDescending;
        }
        
#if DEBUG
        NSAssert(NO, @"CC: You trying to remove source at indexPath %@ twice", indexPath);
#endif
        return NSOrderedSame;
    }];
    

    // We'll need sections to remove sources from, and to remove sections itself in case no more sources left.
    NSMutableArray <CCSection  *> *sections = [self ccSections];
   
    // Here we'll store removed sources to return in the end of it all
    NSMutableArray <CCSource *> *removedSources = [NSMutableArray array];
    
    
    // Let's remove sources by it's indexPaths
    for (NSIndexPath *indexPath in indexPathsToRemove) {
        
#if DEBUG
        if (indexPath.section >= sections.count) {
            NSAssert(NO, @"CC: Section %li does not exist", (long)indexPath.section);
        }
#endif
        
        CCSection *section = sections[indexPath.section];
      
#if DEBUG 
        if (indexPath.row >= section.count) {
            NSAssert(NO, @"CC: Section %li contains only %lu rows. Cannot remove row at index %li", (long) indexPath.section, (unsigned long) section.count, (long) indexPath.row);
        }
#endif
        
        CCSource *source = section.sources[indexPath.row];
        
        [removedSources addObject:source];
        
        [section.sources removeObjectAtIndex:indexPath.row];
    }
    
    
    // Prepare block, which removes rows and sections
    void (^deleteBlock)() = ^void() {
    
        
        // Here we'll store removed sections, to avoid repeated removal.
        NSMutableIndexSet *removedSections = [NSMutableIndexSet indexSet];
        
        // tempIndexPaths stores temporary indexPaths across the section, to be remove later, when section will change
        __block NSMutableArray <NSIndexPath *> *tempIndexPaths = [NSMutableArray array];
        
        // Stores previous section, to find out, when section did change
        __block NSInteger previousSection = -1;
        
        // Block that deletes a pack of tempIndexPaths
        void (^cleanOutTempIndexPathsIfNeedBe)(NSInteger) = ^void(NSInteger currentSection) {
            
            if (currentSection == previousSection) {
                return;     // Return, if sections did not change. Collect them on further
            }
            
            previousSection = currentSection;  // Update previous section
            
            if (tempIndexPaths.count == 0) {
                return;     // Nothing to delte, return
            }
            
            // Delete rows collected over section
            [self _ccDeleteRowsAtIndexPaths:tempIndexPaths animated:animated];
                
            tempIndexPaths = [NSMutableArray array];
        };
        
        
        
        [indexPathsToRemove enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
    
            cleanOutTempIndexPathsIfNeedBe(indexPath.section);
            
            if ([removedSections containsIndex:indexPath.section]) {
                return; // Skip in case section for this indexPath is already deleted
            }
            
            CCSection *section = sections[indexPath.section];
            
            if (section.count == 0) {   // In case section don't contain rows anymore
                
                [sections removeObjectAtIndex:indexPath.section];  // Remove section remove CCSections
                
                [self _ccDeleteSectionAtIndex:indexPath.section animated:animated];
                
                [removedSections addIndex:indexPath.section];   // append section index to skip all indexPaths for this section later
                
            } else {
                
                [tempIndexPaths addObject:indexPath];   // Collect indexPaths over section, to cleanOut it, when section will change
            }
        }];
        
        
        cleanOutTempIndexPathsIfNeedBe(-1); // Final clean out
    };
    
    
    if (indexPathsToRemove.count == 1) {
        
        // We don't need batch update to remove single row
        deleteBlock();
        
    } else {
        
         [self _ccBatchUpdate:deleteBlock];
    }
    
    return removedSources;
}

- (NSMutableArray <NSIndexPath *> *)ccIndexPathsForCellClass:(Class)cellClass {
    
    NSMutableArray <NSIndexPath  *> *paths = [NSMutableArray array];
    
    [[self ccSections] enumerateObjectsUsingBlock:^(CCSection *section, NSUInteger sectionIdx, BOOL * _Nonnull stop) {
       
        [section.sources enumerateObjectsUsingBlock:^(CCSource *source, NSUInteger sourceIdx, BOOL * _Nonnull stop) {
            
            if (source.cellClass == cellClass) {
                
                
                NSIndexPath *path = [NSIndexPath indexPathForItem:sourceIdx inSection:sectionIdx];
                
                [paths addObject:path];
            }
        }];
        
    }];
    
    
    return paths;
}

- (void)ccReloadCellsForClass:(Class)cellClass animated:(BOOL)animated {
    
    NSArray <NSIndexPath  *> *indexPaths = [self ccIndexPathsForCellClass:cellClass];

    for (NSIndexPath *path in indexPaths) {
        
        CCSource *source = [self ccSourceAtIndexPath:path];
        
        [source clearSizesCache];
    }
    
    [self ccReloadCellsForPaths:indexPaths animated:animated];
    
}

- (void)ccDrop {
    
    [[self ccSections] removeAllObjects];
    
    CCSection *cleanSection = [CCSection section];
    
    [[self ccSections] addObject:cleanSection];
    
}

- (void)ccRemoveSourceAtIndex:(NSIndexPath *)indexPath {
    
    CCSection *section = [self ccSectionAtIndex:indexPath.section];
    
    [section.sources removeObjectAtIndex:indexPath.row];
    
}

- (void)ccDropLastSource {
    
    [[[self ccSections] lastObject] dropLastSource];
    
}

- (void)ccRegisterCellClass:(Class)cellClass ofKind:(CoordinatorClassKind)kind {
    
    if (cellClass == nil) {
        return;
    }
    
    if ([[self ccRegisteredCells] containsObject:cellClass]) {
        return;
    }
    
    NSString *className = NSStringFromClass(cellClass);
    
    UINib *nib = nil;
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:kNib];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        
        nib = [UINib nibWithNibName:className bundle:nil];
        
    }
    
    [[self ccRegisteredCells] addObject:cellClass];
    
    
    // Next line calls appropriate method on UITableView or UICollectionView, cause they have different APIs for registering cells
    
    [self registerClass:cellClass nib:nib kind:kind];
    
}



- (void)buildManagerForDelegate:(id)delegate {
    
    CCManager *manager = objc_getAssociatedObject(self, _cmd);
    
    if (manager != nil) {
        return;
    }
    
    if ([self isKindOfClass:[UITableView class]]) {
        
        manager = [[CCManager alloc] initWithTableView: (UITableView*) self delegate:delegate];
        
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        
        manager = [[CCManager alloc] initWithCollectionView: (UICollectionView*) self delegate:delegate];
                   
    }
    
    if (manager == nil) {
        return;
    }
    
    objc_setAssociatedObject(self, _cmd, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)setEditingSectionIndex:(NSInteger)index {
    
    objc_setAssociatedObject(self, @selector(editingSectionIndex), @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSInteger)editingSectionIndex {
    
    NSNumber *index = objc_getAssociatedObject(self, _cmd);
    
    return index == nil ? -1 : [index integerValue];
}

// Helpers

- (void)registerClass:(Class)cellClass nib:(UINib*)nib kind:(CoordinatorClassKind)kind {
  
#if DEBUG
    NSAssert(NO, @"CC: %@ not supported by CellCoordinator", [self class]);
#endif
    
}

- (void)ccReloadCellsForPaths:(NSArray <NSIndexPath *> *)paths animated:(BOOL)animated {
    
#if DEBUG
    NSAssert(NO, @"CC: %@ not supported by CellCoordinator", [self class]);
#endif
    
}

- (void)_ccInsertRowsAtIndexPaths:(NSArray <NSIndexPath  *> *)indexPaths animated:(BOOL)animated {
#if DEBUG
    NSAssert(NO, @"CC: %@ not supported by CellCoordinator", [self class]);
#endif
}

- (void)_ccInsertSectionAtIndex:(NSInteger)index animated:(BOOL)animated {
#if DEBUG
    NSAssert(NO, @"CC: %@ not supported by CellCoordinator", [self class]);
#endif
}

- (void)_ccDeleteSectionAtIndex:(NSInteger)sectionIndex animated:(BOOL)animated {
#if DEBUG
    NSAssert(NO, @"CC: %@ not supported by CellCoordinator", [self class]);
#endif
}

- (void)_ccDeleteRowsAtIndexPaths:(NSArray <NSIndexPath  *> *)indexPaths animated:(BOOL)animated {
#if DEBUG
    NSAssert(NO, @"CC: %@ not supported by CellCoordinator", [self class]);
#endif
}

- (void)_ccBatchUpdate:(void (^)())batchUpdateBlock {
#if DEBUG
    NSAssert(NO, @"CC: %@ not supported by CellCoordinator", [self class]);
#endif
}


@end

@interface UITableView (CellCoordinator)

@end

@implementation UITableView (CellCoordinator)

- (void)registerClass:(Class)cellClass nib:(UINib*)nib kind:(CoordinatorClassKind)kind {
    
    NSString *className = NSStringFromClass(cellClass);
    
    if (nib != nil) {
        
        if (kind == CoordinatorClassCell) {
            [self registerNib:nib forCellReuseIdentifier:className];
        } else {
            [self registerNib:nib forHeaderFooterViewReuseIdentifier:className];
        }
        
        
    } else {
        
        if (kind == CoordinatorClassCell) {
            [self registerClass:cellClass forCellReuseIdentifier:className];
        } else {
            [self registerClass:cellClass forHeaderFooterViewReuseIdentifier:className];
        }
        
    }
    
}

- (void)ccReloadCellsForPaths:(NSArray <NSIndexPath *> *)paths animated:(BOOL)animated {
    
    UITableViewRowAnimation animation = animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone;
    
    [self reloadRowsAtIndexPaths:paths withRowAnimation:animation];
}

- (void)_ccInsertRowsAtIndexPaths:(NSArray <NSIndexPath  *> *)indexPaths animated:(BOOL)animated {
    
    UITableViewRowAnimation animation = animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone;
    
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)_ccInsertSectionAtIndex:(NSInteger)index animated:(BOOL)animated {
    
    UITableViewRowAnimation animation = animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone;
    
    [self insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:animation];
}

- (void)_ccDeleteSectionAtIndex:(NSInteger)sectionIndex animated:(BOOL)animated {
    
    UITableViewRowAnimation animation = animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone;
    
    [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:animation];
}

- (void)_ccDeleteRowsAtIndexPaths:(NSArray <NSIndexPath  *> *)indexPaths animated:(BOOL)animated {
    
    UITableViewRowAnimation animation = animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone;
    
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)_ccBatchUpdate:(void (^)())batchUpdateBlock {
    
    [self beginUpdates];
    
    batchUpdateBlock();
    
    [self endUpdates];
}

@end


@interface UICollectionView (CellCoordinator)

@end

@implementation UICollectionView (CellCoordinator)


- (void)registerClass:(Class)cellClass nib:(UINib*)nib kind:(CoordinatorClassKind)kind {
    
    NSString *className = NSStringFromClass(cellClass);
    
    if (nib != nil) {
        
        switch (kind) {
            case CoordinatorClassCell:
                [self registerNib:nib forCellWithReuseIdentifier:className];
                break;
            case CoordinatorClassHeader:
            case CoordinatorClassFooter:
                [self registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:className];
                [self registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:className];
                break;
        }
        
    } else {
        
        switch (kind) {
            case CoordinatorClassCell:
                [self registerClass:cellClass forCellWithReuseIdentifier:className];
                break;
            case CoordinatorClassHeader:
            case CoordinatorClassFooter:
                [self registerClass:cellClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:className];
                [self registerClass:cellClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:className];
                break;
        }
        
        
    }
    
}

- (void)ccReloadCellsForPaths:(NSArray <NSIndexPath *> *)paths animated:(BOOL)animated {
    
    if (animated) {
        
        [self reloadItemsAtIndexPaths:paths];
    } else {
        
        [UIView performWithoutAnimation:^{
           
            [self reloadItemsAtIndexPaths:paths];
        }];
    }
}

- (void)_ccInsertRowsAtIndexPaths:(NSArray <NSIndexPath  *> *)indexPaths animated:(BOOL)animated {
    
    if (animated) {
        [self insertItemsAtIndexPaths:indexPaths];
    } else {
        
        [UIView performWithoutAnimation:^{
           
            [self reloadItemsAtIndexPaths:indexPaths];
        }];
        
    }
}

- (void)_ccInsertSectionAtIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (animated) {
        
        [self insertSections:[NSIndexSet indexSetWithIndex:index]];
    } else {
        
        [UIView performWithoutAnimation:^{
            [self insertSections:[NSIndexSet indexSetWithIndex:index]];
        }];
    }
    
    
}

- (void)_ccBatchUpdate:(void (^)())batchUpdateBlock {
    
    [self performBatchUpdates:batchUpdateBlock completion:nil];
    
}

- (void)_ccDeleteSectionAtIndex:(NSInteger)sectionIndex animated:(BOOL)animated {
    
    if (animated) {
        
        [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
    } else {
        
        [UIView performWithoutAnimation:^{
            [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
        }];
        
    }
}

- (void)_ccDeleteRowsAtIndexPaths:(NSArray <NSIndexPath  *> *)indexPaths animated:(BOOL)animated {
    
    if (animated) {
        
        [self deleteItemsAtIndexPaths:indexPaths];
    } else {
        
        [UIView performWithoutAnimation:^{
            [self deleteItemsAtIndexPaths:indexPaths];
        }];
        
    }
}


@end







