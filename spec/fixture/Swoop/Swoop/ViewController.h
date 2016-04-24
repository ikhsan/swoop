//
//  ViewController.h
//  Swoop
//
//  Created by Ikhsan Assaat on 24/04/2016.
//  Copyright © 2016 Ikhsan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerDelegate <NSObject>
- (void)protocolMethod;
@end

@interface ViewController : UIViewController

@end

@interface SpecialViewController : ViewController

@end
