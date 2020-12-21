//
//  API.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 18/08/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire
import RSLoadingView


let crrtIP = "http://120.138.10.249/COEAPP/"

let loginAPI = "\(crrtIP)api/codeSlip/getLogin/"

let pgrmAPI = "\(crrtIP)api/codeSlip/GetProgrammcDetails"

let exmnsAPI = "\(crrtIP)api/codeSlip/GetSemDetails/"

let courseAPI = "\(crrtIP)api/codeSlip/GetSubCourseDetails/"

let codeAPI = "\(crrtIP)api/codeSlip/GetCoursePercDetails/"

let award1API = "\(crrtIP)api/codeSlip/GetAwrdSubjctPerc/"

let award2API = "\(crrtIP)api/codeSlip/GetAwrdSubjctValPerc/"

let award3API = "\(crrtIP)api/codeSlip/GetCodeList/"

let practApi = "\(crrtIP)api/codeSlip/GetCollwisePracticalDetails/"

let pract2API = "\(crrtIP)api/codeSlip/GetCollwiseSubjectPracticalDetails/"

let codeSlpAPI = "\(crrtIP)api/codeSlip/GetSubjectDetails/"

let codeSlp2API = "\(crrtIP)api/codeSlip/GetMissingSubjectcodesDetails/"

let intrnlAPI = "\(crrtIP)api/codeSlip/GetClgIntrnlPerc/"

let intrnl2API = "\(crrtIP)api/codeSlip/GetClgSubjctIntrnlPerc/"

let rsltPgrmAPI = "\(crrtIP)api/codeSlip/GetResultPgrms"

let rsltExamAPI = "\(crrtIP)api/codeSlip/GetResultExms/"

let rsltCourseAPI = "\(crrtIP)api/codeSlip/GetResultCourses/"

let rsltSubCourseAPI = "\(crrtIP)api/codeSlip/GetResultSubCourses/"

let rsltsAPI = "\(crrtIP)api/codeSlip/GetResults/"

let memosAPI = "\(crrtIP)api/codeSlip/GetMemos/"

let linkPrgrmAPI = "\(crrtIP)api/codeSlip/GetResultPrograms"

let rsltAPI = "\(crrtIP)api/codeSlip/GetResultsLink/"


let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
//loadingView.shouldTapToDismiss = false

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
