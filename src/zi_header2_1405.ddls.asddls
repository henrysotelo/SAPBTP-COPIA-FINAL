@EndUserText.label: 'Interface - Sales Order Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_HEADER2_1405
  provider contract transactional_interface
  as projection on ZR_HEADER2_1405
{
    key UUID,
        Id,
        Email,
        FirstName,
        LastName,
        Country,
        CreatedOn,
        DeliveryDate,
        OrderStatus,
        ImageUrl,
        
        /* Associations */
        _Item : redirected to composition child ZI_ITEM2_1405,
        _Status
}
