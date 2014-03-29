//
//  PrivacyViewController.m
//  ThisOrThat
//
//  Created by Chase Gorectke on 3/8/14.
//  Copyright (c) 2014 Revision Works, LLC. All rights reserved.
//

#import "CGAttrTextViewController.h"
#import "CGAttrDocParser.h"

@interface CGAttrTextViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, strong) CGAttrDocParser *parser;

@end

@implementation CGAttrTextViewController
@synthesize titleString=_titleString;
@synthesize fileString=_fileString;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:_titleString];
    _parser = [[CGAttrDocParser alloc] initWithFileName:_fileString];
    [self.textView setAttributedText:[_parser attrStringForDoc]];
}

@end
