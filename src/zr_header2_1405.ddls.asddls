@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity - Sales Order Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZR_HEADER2_1405
  as select from zheader_1405
  composition [0..*] of ZR_ITEM2_1405 as _Item
  association [1..1] to ZI_STATUSVH_1405 as _Status on $projection.OrderStatus = _Status.Status
{
  key  uuid                  as UUID,
       id                    as Id,
       email                 as Email,
       first_name            as FirstName,
       last_name             as LastName,
       country               as Country,
       created_on            as CreatedOn,
       delivery_date         as DeliveryDate,
       order_status          as OrderStatus,
       image_url             as ImageUrl,

       @Semantics.user.createdBy: true
       local_created_by      as LocalCreatedBy,
       @Semantics.systemDateTime.createdAt: true
       local_created_at      as LocalCreatedAt,
       @Semantics.user.lastChangedBy: true
       local_last_changed_by as LocalLastChangedBy,
       @Semantics.systemDateTime.lastChangedAt: true
       local_last_changed_at as LocalLastChangedAt,

       //eTag - concurency at OData
       @Semantics.systemDateTime.lastChangedAt: true
       last_changed_at       as LastChangedAt,

       _Item,
       _Status
}
