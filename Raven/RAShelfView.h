//
//  RAShelfView.h
//  Raven
//
//  Created by Thomas Ricouard on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RAShelfView : NSViewController <NSCollectionViewDelegate>
{
    NSMutableArray *appListShelf; 
    IBOutlet NSCollectionView *collectionView; 
    IBOutlet NSCollectionViewItem *collectionViewItem; 
}

@property (nonatomic, assign) NSMutableArray *appListShelf; 

@end
