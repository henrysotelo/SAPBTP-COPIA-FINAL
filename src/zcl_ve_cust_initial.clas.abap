CLASS zcl_ve_cust_initial DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_ve_cust_initial IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA headers TYPE STANDARD TABLE OF zc_header_1405 WITH DEFAULT KEY.
    headers = CORRESPONDING #( it_original_data ).

    LOOP AT headers ASSIGNING FIELD-SYMBOL(<header>).
      <header>-CustImageURL = <header>-ImageUrl.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  headers ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.

ENDCLASS.
