//
//  FollowersVIPListCell.m
//  Followers
//
//  Created by Jesse Ditson on 9/29/12.
//  Copyright (c) 2012 Jesse Ditson. All rights reserved.
//

#import "FollowersVIPListCell.h"

@implementation FollowersVIPListCell

@synthesize image, subtitle;

- (id)copyWithZone:(NSZone *)zone
{
    FollowersVIPListCell *cell = [super copyWithZone:zone];
    if (cell == nil) {
        return nil;
    }
    
    // Clear the image and subtitle as they won't be retained
    cell->image = nil;
    cell->subtitle = nil;
    [cell setImage:[self image]];
    [cell setSubtitle:[self subtitle]];
    
    return cell;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect imageRect = [self imageRectForBounds:cellFrame];
    if (image) {
        [image drawInRect:imageRect 
                 fromRect:NSZeroRect 
                operation:NSCompositeSourceOver
                 fraction:1.0 
           respectFlipped:YES 
                    hints:nil];
    } else {
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:imageRect];
        [[NSColor grayColor] set];
        [path fill];
    }
    
    NSRect titleRect = [self titleRectForBounds:cellFrame];
    NSAttributedString *aTitle = [self attributedStringValue];
    if ([aTitle length] > 0) {
        [aTitle drawInRect:titleRect];
    }
    
    NSRect subtitleRect = [self subtitleRectForBounds:cellFrame forTitleBounds:titleRect];
    NSAttributedString *aSubtitle = [self attributedSubtitleValue];
    if ([aSubtitle length] > 0) {
        [aSubtitle drawInRect:subtitleRect];
    }
}

#define BORDER_SIZE 5
#define IMAGE_SIZE 64

- (NSRect)imageRectForBounds:(NSRect)bounds
{
    NSRect imageRect = bounds;
    
    imageRect.origin.x += BORDER_SIZE;
    imageRect.origin.y += BORDER_SIZE;
    imageRect.size.width = IMAGE_SIZE;
    imageRect.size.height = IMAGE_SIZE;
    
    return imageRect;
}

- (NSRect)titleRectForBounds:(NSRect)bounds
{
    NSRect titleRect = bounds;
    
    titleRect.origin.x += IMAGE_SIZE + (BORDER_SIZE * 2);
    titleRect.origin.y += BORDER_SIZE;
    
    NSAttributedString *title = [self attributedStringValue];
    if (title) {
        titleRect.size = [title size];
    } else {
        titleRect.size = NSZeroSize;
    }

    CGFloat maxX = NSMaxX(bounds);
    CGFloat maxWidth = maxX - NSMinX(titleRect);
    if (maxWidth < 0) {
        maxWidth = 0;
    }
    
    titleRect.size.width = MIN(NSWidth(titleRect), maxWidth);
    
    return titleRect;
}

- (NSRect)subtitleRectForBounds:(NSRect)bounds forTitleBounds:(NSRect)titleBounds
{
    NSRect subtitleRect = bounds;
    
    if (!subtitle) {
        return NSZeroRect;
    }
    
    subtitleRect.origin.x = NSMinX(titleBounds);
    subtitleRect.origin.y = NSMaxY(titleBounds) + BORDER_SIZE;
    
    CGFloat amountPast = NSMaxX(subtitleRect) - NSMaxX(bounds);
    if (amountPast > 0) {
        subtitleRect.size.width -= amountPast;
    }
    
    return subtitleRect;
}

- (NSAttributedString *)attributedSubtitleValue
{
    NSAttributedString *astr = nil;
    
    if (subtitle) {
        NSColor *textColour = [self isHighlighted] ? [NSColor lightGrayColor] : [NSColor grayColor];
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:textColour,
                               NSForegroundColorAttributeName, nil];
        astr = [[NSAttributedString alloc] initWithString:subtitle attributes:attrs];
    }
    
    return astr;
}

@end
