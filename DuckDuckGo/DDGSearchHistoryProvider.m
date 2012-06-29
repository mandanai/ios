//
//  DDGSearchHistoryProvider.m
//  DuckDuckGo
//
//  Created by Ishaan Gulrajani on 3/31/12.
//  Copyright (c) 2012 DuckDuckGo, Inc. All rights reserved.
//

#import "DDGAppDelegate.h"
#import "DDGSearchHistoryProvider.h"

@interface DDGSearchHistoryProvider (Private)
-(NSString *)historyPath;
-(void)removeOldHistoryItemsWithoutSaving;
-(void)save;
@end

@implementation DDGSearchHistoryProvider

static DDGSearchHistoryProvider *sharedInstance;

+(id)sharedInstance {
    if(!sharedInstance)
        sharedInstance = [[self alloc] init];
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if(self) {
        history = [[NSMutableArray alloc] initWithContentsOfFile:self.historyPath];
        if(!history)
            history = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)clear {
    history = [[NSMutableArray alloc] init];
    [self save];
}

-(void)logHistoryItem:(NSString *)historyItem {    
    if(![[DDGAppDelegate retrieveFromUserDefaults:@"history_preference"] boolValue])
        return;
    
    NSDictionary *historyItemDictionary = [NSDictionary dictionaryWithObjectsAndKeys:historyItem,@"text",[NSDate date],@"date",nil];
    
    for(int i=0; i<history.count; i++) {
        if([[[history objectAtIndex:i] objectForKey:@"text"] isEqualToString:historyItem]) {
            // add the new history item at the end to keep the array ordered
            [history removeObjectAtIndex:i];
            [history addObject:historyItemDictionary];
            return;
        }
    }
    [history addObject:historyItemDictionary];
    [self save];
}

-(NSArray *)pastHistoryItemsForPrefix:(NSString *)prefix {
    // there are certain cases in which we don't want to return any history
    if([prefix isEqualToString:@""] || ![[DDGAppDelegate retrieveFromUserDefaults:@"history_preference"] boolValue])
        return [NSArray array];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    for(NSDictionary *historyItem in history) {
        
        NSString *text = [historyItem objectForKey:@"text"];
        if([text hasPrefix:prefix] ||
           [text hasPrefix:[@"http://" stringByAppendingString:prefix]] ||
           [text hasPrefix:[@"https://" stringByAppendingString:prefix]] ||
           [text hasPrefix:[@"http://www." stringByAppendingString:prefix]] ||
           [text hasPrefix:[@"https://www." stringByAppendingString:prefix]]
           )
            [results addObject:historyItem];
    }
    
    // if the array is too large, remove all but the 3 most recent items
    while(results.count > 3)
        [results removeObjectAtIndex:0];

    // the array is currently in ascending chronological order; reverse it and make it non-mutable
    return [[results reverseObjectEnumerator] allObjects];
}

-(void)removeOldHistoryItemsWithoutSaving {
    for(int i=history.count-1; i>=0; i--) {
        // TODO (ishaan): make history interval adjustable? it's currently hard-coded to 30 seconds
        if([[NSDate date] timeIntervalSinceDate:[[history objectAtIndex:i] objectForKey:@"date"]] >= 30*24*60*60)
            [history removeObjectAtIndex:i];
    }
}

-(void)save {
    [self removeOldHistoryItemsWithoutSaving];
    [history writeToFile:self.historyPath atomically:YES];
}

-(NSString *)historyPath {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"history.plist"];
}

@end