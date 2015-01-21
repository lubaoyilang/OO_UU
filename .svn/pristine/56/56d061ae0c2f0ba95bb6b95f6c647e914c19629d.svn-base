//
//  UIImageView+ImageSize.m
//  UThing
//
//  Created by Apple on 15/1/12.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "UIImageView+ImageSize.h"

@implementation UIImageView (ImageSize)

- (void)sz_setImageWithUrlString:(NSString *)urlString imageSize:(NSString *)sizeString options:(SDWebImageOptions)options placeholderImageName:(NSString *)imageName
{
    if (sizeString.length) {
        [self sd_setImageWithURL:[NSURL URLWithString:[urlString replaceCharcter:@"index" withCharcter:sizeString]] placeholderImage:[UIImage imageNamed:imageName] options:options];
    }
    else {
        [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:imageName] options:options];
    }
}

@end
