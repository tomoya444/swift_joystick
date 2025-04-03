//
//  Header.h
//  UXSDKSwiftSample
//
//  Created by Tomoya Usui on 2023/08/05.
//  Copyright © 2023 DJI. All rights reserved.
//

// DJIMissionManager.h

#import <UIKit/UIKit.h>
#import <DJISDK/DJISDK.h>

@interface StudyViewController : UIViewController

- (IBAction)startCircleMissionButtonTapped:(UIButton *)sender;


@end

// 追加：Objective-Cブリッジングヘッダーに追加する内容
void startCircleMissionFromSwift(void);
