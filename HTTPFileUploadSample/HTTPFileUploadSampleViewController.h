//
//  HTTPFileUploadSampleViewController.h
//  HTTPFileUploadSample
//
//  Created by tochi on 11/06/10.
//  Copyright 2011 aguuu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPFileUpload.h"

@interface HTTPFileUploadSampleViewController : UIViewController <HTTPFileUploadDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *codeTextField;
    IBOutlet UIImageView *_imageView;
}

- (IBAction)postButtonClicked:(id)sender;
- (IBAction)showCameraSheet:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *codeTextField;

@end
