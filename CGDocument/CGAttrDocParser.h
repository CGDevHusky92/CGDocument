//
//  AttrDocParser.h
//  ThisOrThat
//
//  Created by Chase Gorectke on 3/8/14.
//  Copyright (c) 2014 Revision Works, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CGAttrDocParser : NSObject

- (id)initWithFileName:(NSString *)fileName;
- (NSAttributedString *)attrStringForDoc;

@end
