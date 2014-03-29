//
//  AttrDocParser.m
//  ThisOrThat
//
//  Created by Chase Gorectke on 3/8/14.
//  Copyright (c) 2014 Revision Works, LLC. All rights reserved.
//

#import "CGAttrDocParser.h"

@interface CGAttrDocParser ()

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *baseString;
@property (nonatomic, strong) NSMutableArray *fileRange;
@property (nonatomic, strong) NSMutableArray *fileAttrs;

@end

@implementation CGAttrDocParser

- (id)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        _fileName = fileName;
        _fileRange = [[NSMutableArray alloc] init];
        _fileAttrs = [[NSMutableArray alloc] init];
        [self loadFile];
    }
    return self;
}

- (void)loadFile
{
    if (!_baseString) _baseString = [[NSString alloc] init];
    NSURL *path = [[NSBundle mainBundle] URLForResource:_fileName withExtension:@""];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[path path]]) {
        int count = 0;
        NSError *error = nil;
        NSString *fileString = [[NSString alloc] initWithContentsOfFile:[path path] encoding:NSUTF8StringEncoding error:&error];
        NSArray *stringComp = [fileString componentsSeparatedByString:@"\n"];
        
        for (NSString *comps in stringComp) {
            int code = [[comps substringToIndex:1] intValue];
            if (code > 0) {
                NSString *subComp = [comps substringFromIndex:1];
                
                [_fileAttrs addObject:[NSNumber numberWithInt:code]];
                [_fileRange addObject:[NSValue valueWithRange:NSMakeRange(count + 1, [subComp length])]];
                
                _baseString = [NSString stringWithFormat:@"%@\n%@", _baseString, subComp];
                count += [subComp length] + 1;
            } else {
                _baseString = [NSString stringWithFormat:@"%@\n", _baseString];
                count += 1;
            }
        }
    }
}

- (NSAttributedString *)attrStringForDoc
{
    if (!_baseString || [_fileRange count] == 0 || [_fileAttrs count] == 0) return nil;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_baseString];
    for (int i = 0; i < [_fileAttrs count]; i++) {
        NSDictionary *attrDic = [self attributesForCode:[[_fileAttrs objectAtIndex:i] intValue]];
        [attrString addAttributes:attrDic range:[[_fileRange objectAtIndex:i] rangeValue]];
    }
    return attrString;
}

- (NSDictionary *)attributesForCode:(int)code
{
    CGFloat fontSize = 0.0;
    NSString *fontName = @"";
    NSNumber *underline = [NSNumber numberWithInteger:NSUnderlineStyleNone];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    
    switch (code) {
        case 1: {
            fontSize = 16.0;
            fontName = @"HelveticaNeue-Bold";
            [style setAlignment:NSTextAlignmentCenter];
            underline = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
            break;
        }
        case 2: {
            fontSize = 14.0;
            fontName = @"HelveticaNeue-Bold";
            [style setAlignment:NSTextAlignmentCenter];
            break;
        }
        case 3: {
            fontSize = 14.0;
            fontName = @"HelveticaNeue-Light";
            [style setAlignment:NSTextAlignmentCenter];
            break;
        }
        case 4: {
            fontSize = 12.0;
            fontName = @"HelveticaNeue-Light";
            [style setAlignment:NSTextAlignmentLeft];
            break;
        }
        case 5:
            underline = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
        case 6: {
            fontSize = 12.0;
            fontName = @"Menlo";
            [style setAlignment:NSTextAlignmentLeft];
            break;
        }
        default:
            break;
    }
    
    if (code < 7 && code > 0) {
        [retDic setObject:underline forKey:NSUnderlineStyleAttributeName];
        [retDic setObject:style forKey:NSParagraphStyleAttributeName];
        [retDic setObject:[UIFont fontWithName:fontName size:fontSize] forKey:NSFontAttributeName];
    }
    
    return retDic;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
