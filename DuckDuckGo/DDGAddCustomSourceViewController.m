//
//  DDGAddCustomSourceViewController.m
//  DuckDuckGo
//
//  Created by Ishaan Gulrajani on 7/24/12.
//
//

#import "DDGAddCustomSourceViewController.h"
#import "DDGStoriesProvider.h"

@implementation DDGAddCustomSourceViewController

-(void)configure {
    self.title = @"Add Source";
    
    [self addTextField:@"News keyword"];
}

-(NSString *)validateData:(NSDictionary *)formData {
    if([[[formData objectForKey:@"News keyword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
        return @"You must enter a news keyword.";
    else
        return nil;
}

-(void)saveData:(NSDictionary *)formData {
    [[DDGStoriesProvider sharedProvider] addCustomSource:[formData objectForKey:@"News keyword"]];
}

@end
