/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalPrivate.h"


@implementation KalMonthView

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        tileAccessibilityFormatter = [[NSDateFormatter alloc] init];
        [tileAccessibilityFormatter setDateFormat:@"EEEE, MMMM d"];
        
        float w = [UIScreen mainScreen].bounds.size.width/7;
        float h = 36.0f;
        
        self.opaque = NO;
        self.clipsToBounds = YES;
        for (int i=0; i<6; i++) {
            for (int j=0; j<7; j++) {
                CGRect r = CGRectMake(j*w, i*h, w, h);
                [self addSubview:[[KalTileView alloc] initWithFrame:r]];
            }
        }
    }
    return self;
}


- (void)checkDate:(NSArray*)dateArray :(int)days
{
    if ([dateArray count] == 0) {
        return;
    }
    
    for (KalTileView *tile in [self subviews]) {
                tile.type =KalTileTypeDisable;
            }
    
    
    NSMutableSet *allSet = [[NSMutableSet alloc] init];
    
    
    for (int i = 0; i<[dateArray count]; i++) {
        
        NSDictionary *dict = [dateArray objectAtIndex:i];
        NSTimeInterval aaa =[[dict objectForKey:@"date"] doubleValue];
        NSDate *dateaa = [NSDate dateWithTimeIntervalSince1970:aaa];
        NSString *dateStr = [dateaa stringWithFormat:@"YYYYMMDD"];
        [allSet addObject:dateStr];
    }
    
    for (KalTileView *tile in [self subviews]) {
        
        NSString *dateStr = [tile.date stringWithFormat:@"YYYYMMDD"];
        if ([allSet containsObject:dateStr]) {
            
            int dd = [tile.date distanceInDaysToDate:[NSDate date]];
            int abDays = abs(dd);
            if (days<=abDays) {
                tile.type =KalTileTypeRegular;
            }else{
                tile.type =KalTileTypeDisable;
            }
            NSLog(@"tDate = %@ dddd = %d",tile.date,dd);
            
            
        }else{
            tile.type =KalTileTypeDisable;
        }
        
    }
    
    
    [self setNeedsDisplay];

}


//- (void)checkDate:(NSArray*)dateArray
//{
//    if ([dateArray count] == 0) {
//        return;
//    }
//    
//    
//    for (KalTileView *tile in [self subviews]) {
//        tile.type =KalTileTypeDisable;
//    }
//
//    for (int i = 0; i<[dateArray count]; i++) {
//        NSDictionary *dict = [dateArray objectAtIndex:i];
//        NSTimeInterval aaa =[[dict objectForKey:@"date"] doubleValue];
//        NSDate *dateaa = [NSDate dateWithTimeIntervalSince1970:aaa];
//        
//        for (int j = 0;j<[[self subviews] count];j++) {
//            KalTileView *tile = [[self subviews] objectAtIndex:j];
//            BOOL isEq  = [tile.date isEqualToDate:dateaa ignore:NSDateIgnoreHour|NSDateIgnoreMin|NSDateIgnoreSecond];
//            if (isEq) {
//                
//                tile.type = KalTileTypeRegular;
//                [tile setNeedsDisplay];
//                break;
//            }
//            
//        }
//        
//        
//        
//    }
//
//}


- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *) trailingAdjacentDates minAvailableDate:(NSDate *)minAvailableDate maxAvailableDate:(NSDate *)maxAvailableDate
{
    int tileNum = 0;
    NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
    
    for (int i=0; i<3; i++) {
        for (int j=0; j<dates[i].count; j++) {
            NSDate *d = dates[i][j];
            KalTileView *tile = [self.subviews objectAtIndex:tileNum];
            [tile resetState];
            tile.date = d;
            if ((minAvailableDate && [d compare:minAvailableDate] == NSOrderedAscending) || (maxAvailableDate && [d compare:maxAvailableDate] == NSOrderedDescending)) {
                tile.type = KalTileTypeDisable;
            }
            if (i == 0 && j == 0) {
                tile.type |= KalTileTypeFirst;
            }
            if (i == 2 && j == dates[i].count-1) {
                tile.type |= KalTileTypeLast;
            }
            if (dates[i] != mainDates) {
                tile.type |= KalTileTypeAdjacent;
            }
            if ([d isToday]) {
                tile.type |= KalTileTypeToday;
                
            }
            tileNum++;
        }
    }
    
    numWeeks = ceilf(tileNum / 7.f);
    [self sizeToFit];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,CGSizeMake([UIScreen mainScreen].bounds.size.width/7, 36.0)}, [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] CGImage]);
}

- (KalTileView *)firstTileOfMonth
{
    KalTileView *tile = nil;
    for (KalTileView *t in self.subviews) {
        if (!t.belongsToAdjacentMonth) {
            tile = t;
            break;
        }
    }
    
    return tile;
}

- (KalTileView *)tileForDate:(NSDate *)date
{
    KalTileView *tile = nil;
    for (KalTileView *t in self.subviews) {
        if ([t.date isEqualToDate:date]) {
            tile = t;
            break;
        }
    }
    return tile;
}

- (void)sizeToFit
{
    self.height = 1.f + 36 * numWeeks;
}

- (void)markTilesForDates:(NSArray *)dates
{
    for (KalTileView *tile in self.subviews)
    {
        if ([dates containsObject:tile.date]) { tile.type |= KalTileTypeMarked; }
        NSString *dayString = [tileAccessibilityFormatter stringFromDate:tile.date];
        if (dayString) {
            NSMutableString *helperText = [[NSMutableString alloc] initWithCapacity:128];
            if ([tile.date isToday])
                [helperText appendFormat:@"%@ ", NSLocalizedString(@"Today", @"Accessibility text for a day tile that represents today")];
            [helperText appendString:dayString];
            if (tile.marked)
                [helperText appendFormat:@". %@", NSLocalizedString(@"Marked", @"Accessibility text for a day tile which is marked with a small dot")];
            [tile setAccessibilityLabel:helperText];
        }
    }
}

#pragma mark -


@end
