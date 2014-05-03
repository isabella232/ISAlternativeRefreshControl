//
//  ISScrollable.h
//  Gambit
//
//  Created by Michael Beauregard on 2014-05-02.
//  Copyright (c) 2014 Robots and Pencils Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISScrollable<NSObject>

@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, readonly, getter=isTracking) BOOL tracking;
@property (nonatomic, assign) UIEdgeInsets contentInset;

@end
