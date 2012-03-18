//
//  HTTPFileUploadSampleViewController.m
//  HTTPFileUploadSample
//
//  Created by tochi on 11/06/10.
//  Copyright 2011 aguuu Inc. All rights reserved.
//

#import "HTTPFileUploadSampleViewController.h"

@implementation HTTPFileUploadSampleViewController
@synthesize codeTextField = _codeTextField;

- (void)dealloc
{
    [_imageView release];
    [_codeTextField release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
    _codeTextField.returnKeyType = UIReturnKeyDone;
    _codeTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_codeTextField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload
{
    [_imageView release];
    _imageView = nil;
    [codeTextField release];
    codeTextField = nil;
    [self setCodeTextField:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)postButtonClicked:(id)sender
{
  // Get image data.
  //UIImage *image1 = [UIImage imageNamed:@"Icon.png"];
  
  // File upload.
  HTTPFileUpload *httpFileUpload = [[HTTPFileUpload alloc] init];
  httpFileUpload.delegate = self;
  [httpFileUpload setPostString:self.codeTextField.text withPostName:@"name"];
  [httpFileUpload setPostImage:_imageView.image withPostName:@"photo" fileName:@"Icon.png"];
  [httpFileUpload postWithUri:@"http://blazing-fog-4408.herokuapp.com/users/photo.json"];
  [httpFileUpload release], httpFileUpload = nil;
}

- (IBAction)showCameraSheet:(id)sender {
    // アクションシートを作る
    UIActionSheet*  sheet;
    sheet = [[UIActionSheet alloc] 
             initWithTitle:@"Select Soruce Type" 
             delegate:self 
             cancelButtonTitle:@"Cancel" 
             destructiveButtonTitle:nil 
             otherButtonTitles:@"Photo Library", @"Camera", @"Saved Photos", nil];
    [sheet autorelease];
    
    // アクションシートを表示する
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet*)actionSheet 
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // ボタンインデックスをチェックする
    if (buttonIndex >= 3) {
        return;
    }
    
    // ソースタイプを決定する
    UIImagePickerControllerSourceType   sourceType = 0;
    switch (buttonIndex) {
        case 0: {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        }
        case 1: {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        }
        case 2: {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        }
    }
    
    // 使用可能かどうかチェックする
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {  
        return;
    }
    
    // イメージピッカーを作る
    UIImagePickerController*    imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker autorelease];
    imagePicker.sourceType = sourceType;
    imagePicker.allowsImageEditing = YES;
    imagePicker.delegate = self;
    
    // イメージピッカーを表示する
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController*)picker 
        didFinishPickingImage:(UIImage*)image 
                  editingInfo:(NSDictionary*)editingInfo
{
    // イメージピッカーを隠す
    [self dismissModalViewControllerAnimated:YES];
    // オリジナル画像を取得する
    UIImage*    originalImage;
    originalImage = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
    
    // グラフィックスコンテキストを作る
    CGSize  size = { 300, 400 };
    UIGraphicsBeginImageContext(size);
    
    // 画像を縮小して描画する
    CGRect  rect;
    rect.origin = CGPointZero;
    rect.size = size;
    [originalImage drawInRect:rect];
    
    // 描画した画像を取得する
    UIImage*    shrinkedImage;
    shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 画像を表示する
    _imageView.image = shrinkedImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    // イメージピッカーを隠す
    [self dismissModalViewControllerAnimated:YES];
}

- (void)httpFileUpload:(NSURLConnection *)connection
      didFailWithError:(NSError *)error
{
  NSLog(@"%@", error);
}

- (void)httpFileUploadDidFinishLoading:(NSURLConnection *)connection
                                result:(NSString *)result
{
  NSLog(@"%@", result);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"" 
                          message:@"投稿完了しました。" 
                          delegate:nil 
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
@end
