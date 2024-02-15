@EndUserText.label: 'Consumption - Sales Order Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Id' ]
define view entity ZC_ITEM_1405
as projection on ZI_ITEM2_1405
{
    key UUID,
        Id,
        HeaderUUID,
        @Search.defaultSearchElement: true
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
        _Header: redirected to parent ZC_HEADER_1405
}
