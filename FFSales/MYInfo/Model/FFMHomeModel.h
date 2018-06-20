//
//  FFMHomeModel.h
//  FFSales
//
//  Created by lin on 2018/6/7.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Model.h"

@interface FFMHomeModel : Model
@property (copy, nonatomic) NSString *custId; //
@property (copy, nonatomic) NSString *custName; //
@property (copy, nonatomic) NSString *sapNo; //
@property (copy, nonatomic) NSString *customerType; //
@property (copy, nonatomic) NSString *custAvator; //
@property (assign, nonatomic) float accountAvailable; //
@property (assign, nonatomic) float marginAvailable; //
@property (assign, nonatomic) float rebateAvailable; //
@property (assign, nonatomic) int deliveryOrderNum; //
@property (assign, nonatomic) int waitAuditOrderNum; //
@property (assign, nonatomic) BOOL needCheckAccount; //

@end
@interface FFMBaseModel : Model
@property (copy, nonatomic) NSString *custId; //
@property (copy, nonatomic) NSString *custName; //
@property (copy, nonatomic) NSString *sapNo; //
@property (copy, nonatomic) NSString *reviewStatus; //
@property (copy, nonatomic) NSString *area; //
@property (copy, nonatomic) NSString *phone; //
@property (copy, nonatomic) NSString *region; //
@property (copy, nonatomic) NSString *detailedAddress; //
@end
@interface FFMidentificationModel : Model
@property (copy, nonatomic) NSString *indentifyId; //
@property (copy, nonatomic) NSString *customerLevel; //
@property (copy, nonatomic) NSString *customerService; //
@property (copy, nonatomic) NSString *customerType; //
@property (copy, nonatomic) NSString *salesOrg; //
@property (copy, nonatomic) NSString *salesCompany; //
@end
@interface FFMBrandModel : Model
@property (copy, nonatomic) NSString *address; //
@property (strong, nonatomic) NSArray<NSString *> *brandNames;
@end
@interface FFMInvoiceModel : Model
@property (copy, nonatomic) NSString *invoiceId; //
@property (copy, nonatomic) NSString *isInvoice; //
@property (copy, nonatomic) NSString *invoiceCompany; //
@property (copy, nonatomic) NSString *invoiceType; //
@property (copy, nonatomic) NSString *taxpayerIdentificationNum; //
@property (copy, nonatomic) NSString *invoiceCompanyAddress; //
@property (copy, nonatomic) NSString *invoiceConpanyPhone; //
@property (copy, nonatomic) NSString *bank; //
@property (copy, nonatomic) NSString *account; //

@end
@interface FFMUserModel : Model
@property (strong, nonatomic) FFMBaseModel *base;
@property (strong, nonatomic) FFMidentificationModel *identification;
@property (strong, nonatomic) NSArray<FFMBrandModel *> *brandAreas;

@property (strong, nonatomic) FFMInvoiceModel *invoice;


@end
