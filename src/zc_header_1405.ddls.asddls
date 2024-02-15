@EndUserText.label: 'Consumption - Sales Order Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Id' ]

define root view entity ZC_HEADER_1405
provider contract transactional_query
as projection on ZI_HEADER2_1405
{
    key UUID,
        Id,
        @Search.defaultSearchElement: true
        Email,
        @Search.defaultSearchElement: true
        FirstName,
        @Search.defaultSearchElement: true
        LastName,
        Country,
        CreatedOn,
        DeliveryDate,
        OrderStatus,
        _Status.Text as OrderStatusText,
        ImageUrl,
        
        @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_VE_CUST_INITIAL'
        @Semantics.imageUrl: true
        virtual CustImageURL: abap.char( 528 ),
        
        /* Associations */
        _Item: redirected to composition child ZC_ITEM_1405,
        _Status
}
