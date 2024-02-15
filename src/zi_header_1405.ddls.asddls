@EndUserText.label: 'Interface - Sales Order Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_HEADER_1405
  provider contract transactional_interface
  as projection on ZR_HEADER_1405
{
    key Id,
        Email,
        FirstName,
        LastName,
        Country,
        CreatedOn,
        DeliveryDate,
        OrderStatus,
        ImageUrl,
        
        /* Associations */
        _Item : redirected to composition child ZI_ITEM_1405
}
