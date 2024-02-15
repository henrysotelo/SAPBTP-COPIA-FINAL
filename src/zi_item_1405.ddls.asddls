@EndUserText.label: 'Interface - Sales Order Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_ITEM_1405
  as projection on ZR_ITEM_1405
{
    key Id,
        HeaderId,
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
        _Header : redirected to parent ZI_HEADER_1405
}
