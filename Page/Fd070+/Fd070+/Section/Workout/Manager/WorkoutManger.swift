//
//  WorkoutManger.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/12.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

struct WorkoutManger {

    static func getUserWorkoutTarget() ->String {

        let workoutSummaryModelLatest = try! WorkoutSummaryDataHelper.FindLatestWorkoutTarget(userID: CurrentUserID, macAddress: CurrentMacAddress)

        if workoutSummaryModelLatest.target == "0" {
            return workoutSummaryModelLatest.target_value + "WorkoutVC_workoutSetTargetVC_distanceUnit".localiz()
        }else {
            return workoutSummaryModelLatest.target_value + "WorkoutVC_workoutSetTargetVC_scheduleUnit".localiz()
        }

    }
}
