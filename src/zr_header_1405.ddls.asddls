@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity - Sales Order Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZR_HEADER_1405
  as select from zheader_1405 
  composition [0..*] of ZR_ITEM_1405 as _Item {
   key    id            as Id,
     uuid          as UUID,
   
        email         as Email,
        first_name    as FirstName,
        last_name     as LastName,
        country       as Country,
        created_on    as CreatedOn,
        delivery_date as DeliveryDate,
        order_status  as OrderStatus,
        image_url     as ImageUrl,
        _Item
}
