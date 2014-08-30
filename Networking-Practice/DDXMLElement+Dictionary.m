//
//  DDXMLElement+Dictionary.m
//  Networking-Practice
//
//  Created by Shoya Ishimaru on 2014/08/30.
//  Copyright (c) 2014年 shoya140. All rights reserved.
//

#import "DDXMLElement+Dictionary.h"

NSString * const kTextNodeKey = @"text";

@implementation DDXMLElement (Dictionary)

- (NSDictionary *)convertDictionary
{
    NSMutableDictionary *elementDict = [NSMutableDictionary dictionary];
    
    for (DDXMLNode *attribute in self.attributes) {
        elementDict[attribute.name] = attribute.stringValue;
    }
    
    for (DDXMLNode *namespace in self.namespaces) {
        elementDict[namespace.name] = namespace.stringValue;
    }
    
    if (self.childCount > 0) {
        for (DDXMLNode *childNode in self.children) {
            if (childNode.kind == DDXMLElementKind) {
                DDXMLElement *childElement = (DDXMLElement *)childNode;
                
                NSString *childElementName = childElement.name;
                NSDictionary *childElementDict = [childElement convertDictionary];
                
                if (elementDict[childElementName] == nil) {
                    [elementDict addEntriesFromDictionary:childElementDict];
                } else if ([elementDict[childElementName] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:elementDict[childElementName]];
                    [items addObject:childElementDict[childElementName]];
                    elementDict[childElementName] = [NSArray arrayWithArray:items];
                } else {
                    NSMutableArray *items = [NSMutableArray array];
                    [items addObject:elementDict[childElementName]];
                    [items addObject:childElementDict[childElementName]];
                    elementDict[childElementName] = [NSArray arrayWithArray:items];
                }
            } else if (childNode.stringValue != nil && childNode.stringValue.length > 0) {
                if (elementDict.count > 0) {
                    elementDict[kTextNodeKey] = childNode.stringValue;
                } else {
                    elementDict[self.name] = childNode.stringValue;
                }
            }
        }
    }
    
    NSDictionary *resultDict = nil;
    
    if (elementDict.count > 0) {
        if (elementDict[self.name]) {
            resultDict = [NSDictionary dictionaryWithDictionary:elementDict];
        } else {
            resultDict = [NSDictionary dictionaryWithObject:elementDict forKey:self.name];
        }
    }
    
    return resultDict;
}

@end