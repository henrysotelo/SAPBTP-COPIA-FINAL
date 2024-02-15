CLASS zcl_data_insert_1405 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_data_insert_1405 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( |----> Sales Order Status data insert| ).

    DATA lwa_1 TYPE zstatus_1405.
    DATA lwa_2 TYPE zstatus_1405.
    DATA lwa_3 TYPE zstatus_1405.
    DATA lwa_4 TYPE zstatus_1405.
    DATA lwa_5 TYPE zstatus_1405.

    lwa_1-status = 1.
    lwa_1-text   = 'Received'.
    lwa_2-status = 2.
    lwa_2-text   = 'Processing'.
    lwa_3-status = 3.
    lwa_3-text   = 'Shipped'.
    lwa_4-status = 4.
    lwa_4-text   = 'Delivered'.
    lwa_5-status = 5.
    lwa_5-text   = 'Canceled'.

    DELETE FROM zstatus_1405.

    INSERT INTO zstatus_1405 VALUES @lwa_1.
    INSERT INTO zstatus_1405 VALUES @lwa_2.
    INSERT INTO zstatus_1405 VALUES @lwa_3.
    INSERT INTO zstatus_1405 VALUES @lwa_4.
    INSERT INTO zstatus_1405 VALUES @lwa_5.
  ENDMETHOD.
ENDCLASS.
