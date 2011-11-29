//
//  CastViewPileUpController.m
//  PushBox
//
//  Created by Gabriel Yeah on 11-11-25.
//  Copyright (c) 2011年 同济大学. All rights reserved.
//

#import "CastViewPileUpController.h"

#define kCastViewPageNumberInSection 10

@implementation CastViewPileUpController

static CastViewPileUpController *_sharedCastViewPileUpController = nil;

@synthesize castViewPiles = _castViewPiles;
@synthesize currentViewIndex = _currentViewIndex;
@synthesize lastIndexFR = _lastIndexInFR;

+ (CastViewPileUpController*)sharedCastViewPileUpController
{
	if (_sharedCastViewPileUpController == nil) {
		_sharedCastViewPileUpController = [[CastViewPileUpController alloc] init];
	}
	return _sharedCastViewPileUpController;
}


#pragma mark - Life cycle

- (void)dealloc
{
	[_castViewPiles release];
	[_newReadIDSet release];
	[_oldReadIDSet release];
	[super dealloc];
}

- (id)init
{
	if (self = [super init]) {
		_currentViewIndex = 0;
        _lastIndexInFR = 0;
		_castViewPiles = [[NSMutableArray alloc] init];
		_oldReadIDSet = [[NSMutableSet alloc] init];
		_newReadIDSet = [[NSMutableSet alloc] init];
	}
	
	return self;
}

#pragma mark - Tools

- (CastViewPile*)pileAtIndex:(int)index
{
    if (index >= _castViewPiles.count || index < 0) {
        NSLog(@"Pile over range when getting pile at index: %d", index);
        return CastViewCellTypeCard;
    }
    CastViewPile *pile = [_castViewPiles objectAtIndex:index];
    return pile;
}


- (BOOL)pile:(CastViewPile *)pile shouldContainIndexInFR:(int)index
{
	BOOL result = NO;
    
    NSLog(@"end index : %d and index : %d", pile.endIndexInFR , index);
    
	if (pile != nil) {
		if (pile.endIndexInFR == index - 1) {
			[pile enlargePileVolume];
			result = YES;
		} else if(pile.endIndexInFR > index - 1 && pile.startIndexInFR <= index - 1){
            result = YES;
        }
	}
	return result;
}

#pragma mark - Construction

- (void)insertCardwithID:(long long)statusID andIndexInFR:(int)index
{
    
	NSNumber *number = [NSNumber numberWithLongLong:statusID];
    
    NSLog(@"adding %d with id %lld", index, statusID);

	if (/*[_oldReadIDSet containsObject:number] || */ [_newReadIDSet containsObject:number]) {
	
        BOOL pileFound = NO;
        
        for (int i = 0; i < _castViewPiles.count; ++i) {
            CastViewPile *pile = [_castViewPiles objectAtIndex:i];
            
            if ([pile containsIndexInFR:index]) {
                
                pileFound = YES;
                break;
            } else if ([pile isPileTail:index]) {
                
                [pile enlargePileVolume];
                pileFound = YES;
                break;
            }
        }
        
        if (!pileFound) {
            CastViewPile *newPile = [[[CastViewPile alloc] initWithStartIndexInFR:index] autorelease];
            newPile.type = CastViewCellTypeSingleCardPile;
            newPile.isRead = YES;
            
			[_castViewPiles addObject:newPile];
			_currentViewIndex++;
        }

	} else {
        
        NSLog(@"%lld is not in readSet", statusID);
        
        CastViewPile *newPile = [[[CastViewPile alloc] initWithStartIndexInFR:index] autorelease];
        newPile.type = CastViewCellTypeCard;
        newPile.isRead = NO;
        
        [_castViewPiles addObject:newPile];
		_currentViewIndex++;
	}
	
}

- (int)indexInFRForViewIndex:(int)index
{
    if (index >= _castViewPiles.count || index < 0) {
        return 0;
    }
    CastViewPile *pile = [_castViewPiles objectAtIndex:index];
    NSLog(@"indexInFR : %d ______ index : %d", pile.startIndexInFR , index);
    return pile.startIndexInFR;
}

- (int)itemCount
{
    return _castViewPiles.count;
}

- (void)print
{
    NSLog(@"pile num is %d", _castViewPiles.count);
	for (int i = 0; i < _castViewPiles.count; ++i) {
		CastViewPile *pile = [_castViewPiles objectAtIndex:i];
		for (int j = pile.startIndexInFR; j <= pile.endIndexInFR; ++j) {
			NSLog(@"___%d  ", j);
		}
		NSLog(@"\n");
	}
}

#pragma mark - Destruction



- (void)deletePileAtIndex:(int)index
{
    if (index >= _castViewPiles.count || index < 0) {
        NSLog(@"Pile over range when deleting pile at index: %d", index);
        return;
    }
    CastViewPile *pile = [_castViewPiles objectAtIndex:index];

    if (pile.type == CastViewCellTypeMutipleCardPile ) {
        for (int i = pile.endIndexInFR; i >= pile.startIndexInFR ; --i) {
            CastViewPile *newPile = [[[CastViewPile alloc] initWithStartIndexInFR:i] autorelease];
            newPile.type = CastViewCellTypeCard;
            newPile.isRead = YES;
            
            [_castViewPiles insertObject:newPile atIndex:index];
        }
    } else {
        for (int i = index + 1; i < _castViewPiles.count; ++i) {
            CastViewPile *tmp = [_castViewPiles objectAtIndex:i];
            [tmp resetAfterDeleting];
        }
    }
    
    [_castViewPiles removeObject:pile];
    
    
    [self print];
}

- (void)clearPiles
{
	[_castViewPiles removeAllObjects];
	_currentViewIndex = 0;
    _lastIndexInFR = 0;
}

#pragma mark - Operations on Piles

- (void)addNewReadID:(long long)readStatusID
{
    if (![_newReadIDSet containsObject:[NSNumber numberWithLongLong:readStatusID]]) {
        [_newReadIDSet addObject:[NSNumber numberWithLongLong:readStatusID]];
        NSLog(@"%lld already in readSet", readStatusID);
        
    }
    NSLog(@"readSet size is %d", _newReadIDSet.count);
}

@end