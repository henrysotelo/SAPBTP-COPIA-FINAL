@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity - Sales Order Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_ITEM2_1405
  as select from zitem_1405
  association to parent ZR_HEADER2_1405 as _Header on $projection.HeaderUUID = _Header.UUID
{
  key uuid                  as UUID,
      id                    as Id,
      header_uuid           as HeaderUUID,
      name                  as Name,
      description           as Description,
      releasedate           as ReleaseDate,
      discontinueddate      as DiscontinuedDate,
      price                 as Price,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      height                as Height,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      width                 as Width,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      depth                 as Depth,
      quantity              as Quantity,
      unitofmeasure         as UnitOfMeasure,

      //local ETag field --> OData ETag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Header
}
