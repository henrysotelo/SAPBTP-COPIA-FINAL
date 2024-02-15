@EndUserText.label: 'Interface - Sales Order Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_ITEM2_1405
  as projection on ZR_ITEM2_1405
{
    key UUID,
        Id,
        HeaderUUID,
        Name,
        Description,
        ReleaseDate,
        DiscontinuedDate,
        Price,
        Height,
        Width,
        Depth,
        Quantity,
        UnitOfMeasure,
        
        /* Associations */
        _Header : redirected to parent ZI_HEADER2_1405
}
