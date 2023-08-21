//
//  DJIMissionManager.m
//  UXSDKSwiftSample
//
//  Created by Tomoya Usui on 2023/08/05.
//  Copyright © 2023 DJI. All rights reserved.
//

#import "DJIMissionManager.h"

@interface StudyViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation StudyViewController

- (IBAction)startCircleMissionButtonTapped:(UIButton *)sender {
    [self startCircleMission];
}

- (void)startCircleMissionFromSwift {
    [self startCircleMission];
}

- (void)startCircleMission {
    DJIHotpointMissionOperator *hotpointMissionOperator = [[DJISDKManager missionControl] hotpointMissionOperator];
    
    if (!hotpointMissionOperator) {
        NSLog(@"Failed to get hotpoint mission operator");
        return;
    }

    DJIHotpointMissionState state = hotpointMissionOperator.currentState;
    if (state != DJIHotpointMissionStateReadyToStart) {
        NSLog(@"Cannot start hotpoint mission because it's not in the ReadyToStart state. Current state: %ld", (long)state);
        return;
    }

    CLLocationCoordinate2D currentLocation;
    currentLocation.latitude = 35.71104;  // 例: 東京の緯度
    currentLocation.longitude = 139.62681; // 例: 東京の経度
    
    
    // HotpointMissionの作成
    DJIHotpointMission *hotpointMission = [[DJIHotpointMission alloc] init];
    hotpointMission.hotpoint = currentLocation;
    hotpointMission.radius = 5.0;
    hotpointMission.altitude = 5.0;
    
    // HotpointMissionを開始
    [hotpointMissionOperator startMission:hotpointMission withCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to start circle mission: %@", error.localizedDescription);
        } else {
            NSLog(@"Circle mission started");
        }
    }];
}



@end

// 追加：Objective-Cブリッジングヘッダーに追加する内容
void startCircleMissionFromSwift(void) {
    StudyViewController *viewController = [[StudyViewController alloc] init];
    [viewController startCircleMission];
}

