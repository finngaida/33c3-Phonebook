//
//  FGDatenSchleuder.m
//  #31c3
//
//  Created by Finn Gaida on 29.12.14.
//  Copyright (c) 2014 Finn Gaida. All rights reserved.
//

#import "FGDatenSchleuder.h"

@implementation FGDatenSchleuder

- (id)init {
    
    self = [super init];
    
    NSError *error;
    NSArray *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Phonebook" ofType:@"json"]] options:NSJSONReadingMutableLeaves error:&error];
    
    if (error)
        self.jsonDict = @[@"error"];
    else
        self.jsonDict = dict;
    
    return self;
}

@end
