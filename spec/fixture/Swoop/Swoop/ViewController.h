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

// @interface _ViewController : UIViewController
//
// @end
//
// @interface _SpecialViewController : _ViewController
//
// @end

@interface SpecialViewController (Extension)

@end

@interface SpecialViewController ()

@end

// @interface _SpecialViewController ()
// @end

typedef struct {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
} Color;

struct Book
{
   NSString *title;
   NSString *author;
   int book_id;
} book;

typedef struct {
    int lat,
    int long,
} Coordinate;

// struct _Book
// {
//    NSString *title;
//    NSString *author;
//    int book_id;
// } book;

// typedef struct {
//     int lat,
//     int long,
// } _Coordinate;
