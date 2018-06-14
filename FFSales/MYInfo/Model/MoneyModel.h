//
//  MoneyModel.h
//  FFSales
//
//  Created by lin on 2018/6/13.
//  Copyright © 2018年 lin. All rights reserved.
//

#import "Model.h"
@interface MoneySmallModel : Model
@property (copy, nonatomic) NSString *serviceType;//
@property (copy, nonatomic) NSString *priceBatch;//
@property (copy, nonatomic) NSString *childrenAccountType;//
@property (assign, nonatomic) float amt;
@property (assign, nonatomic) int status;
@property (assign, nonatomic) long opTime;
@end
@interface moneyTypeModel : Model
@property (assign, nonatomic) float availableBalance;
@property (copy, nonatomic) NSString *serviceType;//    业务类型（01：复肥；02：盐；03：酒；04：联碱）
@property (strong, nonatomic) NSArray<MoneySmallModel *> *records;
@end
@interface MoneyModel : Model
@property (assign, nonatomic) float amount;
@property (strong, nonatomic) NSArray<moneyTypeModel *> *accountInfos;

@end

@interface creaditSmallModel : Model
@property (copy, nonatomic) NSString *childrenAccountType;

@property (assign, nonatomic) float availableBalance;
@property (assign, nonatomic) float alreadyRepayment;
@property (assign, nonatomic) float needPayment;
@end
@interface creaditTypeModel : Model
@property (copy, nonatomic) NSString *serviceType;//    业务类型（01：复肥；02：盐；03：酒；04：联碱）
@property (strong, nonatomic) NSArray<creaditSmallModel *> *accountInfos;
@end
@interface creaditModel : Model
@property (strong, nonatomic) NSArray<creaditTypeModel *> *list;
@end

@interface SubCreaditSmallModel : Model
@property (copy, nonatomic) NSString *accountId;

@property (copy, nonatomic) NSString *childrenAccountType;
@property (assign, nonatomic) float availableBalance;
@property (assign, nonatomic) float alreadyRepayment;
@property (assign, nonatomic) float needPayment;
@property (assign, nonatomic) float approvedAmount;
@property (assign, nonatomic) long endDate;
@property (assign, nonatomic) int overdays;

@end
@interface SubCreaditModel : Model
@property (strong, nonatomic) NSArray<SubCreaditSmallModel *> *list;
@end

@interface CreaditDetailModel : Model
@property (copy, nonatomic) NSString *accountId;
@property (copy, nonatomic) NSString *childrenAccountType;
@property (copy, nonatomic) NSString *serviceType;
@property (copy, nonatomic) NSString *custName;

@property (copy, nonatomic) NSString *saleCompany;
@property (assign, nonatomic) float availableBalance;
@property (assign, nonatomic) float alreadyRepayment;
@property (assign, nonatomic) float needPayment;
@property (assign, nonatomic) float approvedAmount;
@property (assign, nonatomic) long endDate;
@property (assign, nonatomic) long beginDate;
@property (assign, nonatomic) long repayDate;
@property (assign, nonatomic) float rate;
@property (assign, nonatomic) long inputDate;

@end

@interface SubHistoryModel : Model
@property (copy, nonatomic) NSString *accountId;

@property (copy, nonatomic) NSString *childrenAccountType;
@property (assign, nonatomic) float amt;
@property (assign, nonatomic) long opTime;
@property (assign, nonatomic) int status;
@end
@interface HistoryModel : Model
@property (strong, nonatomic) NSArray<SubHistoryModel *> *list;
@end


@interface OtherMoneySmallModel : Model
@property (copy, nonatomic) NSString *serviceType;//业务类型（01：复肥；02：盐；03：酒；04：联碱）
@property (assign, nonatomic) float accountBalance;
@property (assign, nonatomic) float alreadyRepayment;
@property (assign, nonatomic) float needPayment;
@end
@interface OtherMoneyTypeModel : Model
@property (copy, nonatomic) NSString *childrenAccountType;//
@property (assign, nonatomic) float amount;

@property (strong, nonatomic) NSArray<OtherMoneySmallModel *> *accountInfos;
@end
@interface OtherMoney : Model
@property (strong, nonatomic) NSArray<OtherMoneyTypeModel *> *list;
@end


@interface BackMoneyTypeModel : Model
@property (copy, nonatomic) NSString *serviceType;//
@property (assign, nonatomic) float availableBalance;
@property (assign, nonatomic) float lockAmount;
@end
@interface BackMoney : Model
@property (strong, nonatomic) NSArray<BackMoneyTypeModel *> *list;
@end


@interface ListSubModel : Model
@property (copy, nonatomic) NSString *flowNo;//
@property (copy, nonatomic) NSString *serviceType;//
@property (copy, nonatomic) NSString *fundType;//
@property (assign, nonatomic) long inputDate;

@property (assign, nonatomic) float addAmt;
@property (assign, nonatomic) float plusAmt;
@end
@interface ListModel : Model
@property (strong, nonatomic) NSArray<ListSubModel *> *list;
@end
