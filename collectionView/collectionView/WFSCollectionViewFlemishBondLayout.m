//
//  WFSCollectionViewFlemishBondLayout.m
//  WFSCollectionViewFlemishBondLayout
//
//  Created by Rafael Aguilar Martín on 13/10/13.
//  Copyright (c) 2013 Rafael Aguilar Martín. All rights reserved.
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "WFSCollectionViewFlemishBondLayout.h"

static NSString *const WFSCollectionViewFlemishBondCellKind = @"WFSCollectionViewFlemishBondCellKind";
NSString *const WFSCollectionViewFlemishBondHeaderKind = @"WFSCollectionViewFlemishBondHeaderKind";
NSString *const WFSCollectionViewFlemishBondFooterKind = @"WFSCollectionViewFlemishBondFooterKind";

@interface WFSCollectionViewFlemishBondLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic, strong) NSDictionary *headerLayoutInfo;
@property (nonatomic, strong) NSDictionary *footerLayoutInfo;
@property (nonatomic, strong) NSMutableDictionary *headerSizes;
@property (nonatomic, strong) NSMutableDictionary *footerSizes;
@property (nonatomic, readonly) CGFloat cellWidth;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, readonly) NSInteger numberOfSections;
@property (nonatomic, readonly) CGFloat totalHeaderHeight;
@property (nonatomic, readonly) CGFloat totalFooterHeight;
@property (nonatomic, assign) WFSCollectionViewFlemishBondLayoutGroupDirection highlightedCellDirection;

@end

@implementation WFSCollectionViewFlemishBondLayout

#pragma mark - Lifecycle
- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

#pragma mark - Custom Getter
/**
 * cell宽度
 */
- (CGFloat)cellWidth
{
    return self.collectionView.bounds.size.width - self.highlightedCellWidth;
}

/**
 * cell高度
 */
- (CGFloat)cellHeight
{
    return self.highlightedCellHeight / (self.numberOfElements - 1);
}
/**
 * 分区数量
 */
- (NSInteger)numberOfSections
{
    return [self.collectionView numberOfSections];
}
/**
 * 分区头总高度
 */
- (CGFloat)totalHeaderHeight
{
    CGFloat totalHeight = 0.0f;
    
    for (NSIndexPath *indexPath in self.headerSizes) {
        NSValue *value = [self.headerSizes objectForKey:indexPath];
        
        CGSize size = [value CGSizeValue];
        
        totalHeight += size.height;
    }
    
    return totalHeight;
}
/**
 * 分区尾总高度
 */
-(CGFloat)totalFooterHeight
{
    CGFloat totalHeight = 0.0f;
    
    for (NSIndexPath *indexPath in self.footerSizes) {
        NSValue *value = [self.footerSizes objectForKey:indexPath];
        
        CGSize size = [value CGSizeValue];
        
        totalHeight += size.height;
    }
    return totalHeight;

}
/**
 * 指定分区头高度
 */
- (CGFloat)totalHeaderHeightAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat totalHeight = 0.0f;
    
    for (NSInteger section; section<indexPath.section; section++)
    {
        NSIndexPath *indexPaths = [NSIndexPath indexPathForItem:0 inSection:section];
        NSValue *value = [self.headerSizes objectForKey:indexPaths];
        
        CGSize size = [value CGSizeValue];
        
        totalHeight += size.height;

    }
    return totalHeight;
}
/**
 * 累积分区头高度
 */
- (CGFloat)totalHeaderHeightToIndexPath:(NSIndexPath *)indexPath
{
    CGFloat totalHeight = 0.0f;
    
    for (NSInteger section = 0; section < indexPath.section+1; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        
        NSValue *value = [self.headerSizes objectForKey:indexPath];
        
        CGSize size = [value CGSizeValue];
        
        totalHeight += size.height;
    }
    
    return totalHeight;
}
/**
 * 指定区的高度
 */
- (CGFloat)totalFooterHeightAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat totalHeight = 0.0f;
    
    for (NSInteger section; section<indexPath.section; section++)
    {
        NSIndexPath *indexPaths = [NSIndexPath indexPathForItem:0 inSection:section];
        NSValue *value = [self.headerSizes objectForKey:indexPaths];
        
        CGSize size = [value CGSizeValue];
        
        totalHeight += size.height;
        
    }
    return totalHeight;
}

#pragma mark - Setup
- (void)setup
{
    // Default values
    self.numberOfElements = 3;
    self.highlightedCellHeight = 200.0f;
    self.highlightedCellWidth = 0.0f;
}

#pragma mark - UICollectionViewLayout
+ (Class)layoutAttributesClass
{
    return [WFSCollectionViewFlemishBondLayoutAttributes class];
}
/**
 * 准备布局
 */
- (void)prepareLayout
{
    NSMutableDictionary *newLayoutDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerLayoutDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *footerLayoutDictionary = [NSMutableDictionary dictionary];
    
    self.headerSizes = [NSMutableDictionary dictionary];
    self.footerSizes = [NSMutableDictionary dictionary];
    [self checkHighlightedCellWidth];
    
    for (NSInteger section = 0; section < self.numberOfSections; section++) {
        NSInteger itemsCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemsCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];

            if (indexPath.item == 0) {
                if ([self.delegate conformsToProtocol:@protocol(WFSCollectionViewFlemishBondLayoutDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:layout:estimatedSizeForHeaderInSection:)]) {
                    CGSize size = [self.delegate collectionView:self.collectionView layout:self estimatedSizeForHeaderInSection:section];
                    self.headerSizes[indexPath] = [NSValue valueWithCGSize:size];
                    UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes
                                                                          layoutAttributesForSupplementaryViewOfKind:WFSCollectionViewFlemishBondHeaderKind
                                                                          withIndexPath:indexPath];
                    headerAttributes.frame = [self frameForHeaderAtIndexPath:indexPath withSize:size];
                    headerLayoutDictionary[indexPath] = headerAttributes;
                }
            }
                else if([self isTheLastItemAtIndexPath:indexPath]) {
                if ([self.delegate conformsToProtocol:@protocol(WFSCollectionViewFlemishBondLayoutDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:layout:estimatedSizeForFooterInSection:)]) {
                    CGSize size = [self.delegate collectionView:self.collectionView layout:self estimatedSizeForFooterInSection:section];
                  NSIndexPath *lastindexPath = [NSIndexPath indexPathForItem:item-1 inSection:section];
                    self.footerSizes[lastindexPath] = [NSValue valueWithCGSize:size];
                   UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes
                                                                          layoutAttributesForSupplementaryViewOfKind:WFSCollectionViewFlemishBondFooterKind
                                                                          withIndexPath:lastindexPath];
            
                    footerAttributes.frame = [self frameForFooterAtIndexPath:lastindexPath withSize:size];
                    footerLayoutDictionary[lastindexPath] = footerAttributes;
                    
                }
            }
            
            WFSCollectionViewFlemishBondLayoutAttributes *layoutAttributes = [WFSCollectionViewFlemishBondLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            layoutAttributes.frame = [self frameForCellAtIndexPath:indexPath];
            layoutAttributes.highlightedCell = [self isHighLightedElementAtIndexPath:indexPath];
            layoutAttributes.highlightedCellDirection = self.highlightedCellDirection;
            
            cellLayoutDictionary[indexPath] = layoutAttributes;
        }
    }
    
    newLayoutDictionary[WFSCollectionViewFlemishBondCellKind] = cellLayoutDictionary;
    newLayoutDictionary[WFSCollectionViewFlemishBondHeaderKind] = headerLayoutDictionary;
    newLayoutDictionary[WFSCollectionViewFlemishBondFooterKind] = footerLayoutDictionary;
    
    self.layoutInfo = newLayoutDictionary;
}
/**
 * 返回显示区域的布局
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}
/**
 * 返回所有的布局
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[WFSCollectionViewFlemishBondCellKind][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[kind][indexPath];
}
/**
 * 返回contentsize
 */
- (CGSize)collectionViewContentSize
{
    if ([self itemCountAtSection:0] == 0) {
		return CGSizeZero;
	}
    return CGSizeMake(self.collectionView.bounds.size.width, (self.highlightedCellHeight  * [self totalGroupsInCollectionView]) + self.totalHeaderHeight + self.totalFooterHeight);
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark - Private Methods
- (CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = CGRectZero;
    
    if ([self isHighLightedElementAtIndexPath:indexPath]) {
        if ([self.delegate conformsToProtocol:@protocol(WFSCollectionViewFlemishBondLayoutDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:layout:highlightedCellDirectionForGroup:atIndexPath:)]) {
            self.highlightedCellDirection = [self.delegate collectionView:self.collectionView layout:self highlightedCellDirectionForGroup:[self currentGroupAtIndexPath:indexPath] atIndexPath:indexPath];
        } else {
            self.highlightedCellDirection = WFSCollectionViewFlemishBondLayoutGroupDirectionLeft;
        }
        
        CGFloat coordinateX;
        
        if (self.highlightedCellDirection == WFSCollectionViewFlemishBondLayoutGroupDirectionLeft) {
            coordinateX = 0;
        } else {
            coordinateX = self.cellWidth;
        }
        
        frame = CGRectMake(coordinateX, [self getYAtIndexPath:indexPath], self.highlightedCellWidth, self.highlightedCellHeight);
    } else {
        CGFloat coordinateX;
        if (self.highlightedCellDirection == WFSCollectionViewFlemishBondLayoutGroupDirectionLeft) {
            coordinateX = self.highlightedCellWidth;
        } else {
            coordinateX = 0;
        }
        
        frame = CGRectMake(coordinateX, [self getYAtIndexPath:indexPath], self.cellWidth, self.cellHeight);
    }
    
    return frame;
}
/**
 * headerView Frame
 */
- (CGRect)frameForHeaderAtIndexPath:(NSIndexPath *)indexPath withSize:(CGSize)size
{
    CGRect frame = [self frameForCellAtIndexPath:indexPath];
    if (frame.origin.y == size.height) {
        frame.origin.y = 0;
    } else {
        frame.origin.y-= frame.size.height;
        frame.origin.y += self.highlightedCellHeight+[self heightFooterAtIndexPath:indexPath];
        frame.origin.y -= [self.headerSizes[indexPath] CGSizeValue].height;
    }

    frame.origin.x = 0.0f;
    frame.size = size;
    return frame;
}
/**
 * footerView Frame
 */
- (CGRect)frameForFooterAtIndexPath:(NSIndexPath *)indexPath withSize:(CGSize)size
{
    CGRect frame = [self frameForCellAtIndexPath:indexPath];
    frame.origin.y += self.highlightedCellHeight;
    if (indexPath.section>0) {
        frame.origin.y -= [self heightFooterAtIndexPath:indexPath];
    }
    frame.origin.x = 0.0f;
    frame.size = size;
    return frame;
}
/**
 * 获取Y值
 */
- (CGFloat)getYAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentGroup = [self currentGroupAtIndexPath:indexPath];
    CGFloat yValue = 0.0f;
    NSIndexPath *indexPathFirstElementCurrentSection = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];


    if (indexPath.section>0)
    {
        NSIndexPath *lastIndexpath = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section-1];
        if ([self isHighLightedElementAtIndexPath:indexPath]) {
            yValue = (currentGroup - 1) * self.highlightedCellHeight + [self heightHeaderAtIndexPath:indexPathFirstElementCurrentSection]+self.highlightedCellHeight  * [self totalGroupsToIndexPath:lastIndexpath] +[self totalHeaderHeightToIndexPath:lastIndexpath];
        } else {
            NSInteger position;
            if (indexPath.row <= self.numberOfElements) {
                position = (indexPath.row - 1);
            } else {
                NSInteger maxElement = self.numberOfElements * currentGroup;
                position = (indexPath.row - 1) - (maxElement - self.numberOfElements);
            }
    
            yValue = ((currentGroup - 1) * self.highlightedCellHeight) + (self.cellHeight * position) + [self heightHeaderAtIndexPath:indexPathFirstElementCurrentSection]+self.highlightedCellHeight  * [self totalGroupsToIndexPath:lastIndexpath] +[self totalHeaderHeightToIndexPath:lastIndexpath];
        }
    }
    else
    {
        if ([self isHighLightedElementAtIndexPath:indexPath]) {
            yValue = (currentGroup - 1) * self.highlightedCellHeight + [self heightHeaderAtIndexPath:indexPathFirstElementCurrentSection];
        } else {
            NSInteger position;
            if (indexPath.row <= self.numberOfElements) {
                position = (indexPath.row - 1);
            } else {
                NSInteger maxElement = self.numberOfElements * currentGroup;
                position = (indexPath.row - 1) - (maxElement - self.numberOfElements);
            }
            yValue = ((currentGroup - 1) * self.highlightedCellHeight) + (self.cellHeight * position) + [self heightHeaderAtIndexPath:indexPathFirstElementCurrentSection];
        }
    }
    return yValue;
}
/**
 * 是否是大的item
 */
- (BOOL)isHighLightedElementAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row % self.numberOfElements) == 0) {
        return YES;
    }
    
    return NO;
}
/**
 * 当前模块
 */
- (NSInteger)currentGroupAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.row + 1;
    
    NSInteger resultValue = item / self.numberOfElements;
    
    NSUInteger mod = item % self.numberOfElements;
    if (mod > 0) {
        resultValue += 1;
    }
    
    return resultValue;
}
/**
 * 指定分区下的模块数  模块就是包含一个大item
 */
- (NSInteger)totalGroupsAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:indexPath.section];
    
    if (itemsCount <= self.numberOfElements) {
        return 1;
    }
    
    NSInteger resultValue = itemsCount / self.numberOfElements;
    
    NSUInteger mod = itemsCount % self.numberOfElements;
    if (mod > 0) {
        resultValue += 1;
    }
    return resultValue;
}

/**
 * 累积的模块数量
 */
- (NSInteger)totalGroupsToIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalGroups = 0;
    for (NSInteger section = 0; section < indexPath.section+1; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        
        totalGroups += [self totalGroupsAtIndexPath:indexPath];
    }
    return totalGroups;
}

/**
 * 整个collection的模块数量
 */
- (NSInteger)totalGroupsInCollectionView
{
    NSInteger totalGroups = 0;
    for (NSInteger section = 0; section < self.numberOfSections; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        
        totalGroups += [self totalGroupsAtIndexPath:indexPath];
    }
    
    return totalGroups;
}
/**
 * 指定分区的头视图size
 */
- (CGFloat)heightHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [self.headerSizes[indexPath] CGSizeValue];
    return size.height;
}
/**
 * 指定分区的尾视图size
 */
- (CGFloat)heightFooterAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [self.footerSizes[indexPath] CGSizeValue];
    return size.height;
}
/**
 *  每个分区item的数量
 */
- (NSInteger)itemCountAtSection:(NSInteger)section
{

    return [[self collectionView] numberOfItemsInSection:section];
}
/**
 *  是否是分区最后一个item
 */
- (BOOL)isTheLastItemAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.row + 1) == [self itemCountAtSection:indexPath.section]) {
        return YES;
    }
    
    return NO;
}
/**
 *  检查是否设置了宽度
 */
- (void)checkHighlightedCellWidth
{
    if (self.highlightedCellWidth == 0) {
        self.highlightedCellWidth = self.collectionView.bounds.size.width / 2;
    }
}

@end
