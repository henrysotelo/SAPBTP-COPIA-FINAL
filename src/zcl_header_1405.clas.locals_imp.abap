CLASS lhc_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS :
      BEGIN OF header_status,
        received   TYPE n LENGTH 1 VALUE 1, " Received
        processing TYPE n LENGTH 1 VALUE 2, " Processing
        shipped    TYPE n LENGTH 1 VALUE 3, " Shipped
        delivered  TYPE n LENGTH 1 VALUE 4, " Delivered
        canceled   TYPE n LENGTH 1 VALUE 5, " Canceled
      END OF header_status,

      BEGIN OF unit_of_measure,
        m  TYPE c LENGTH 2 VALUE 'm',  " millimeters
        cm TYPE c LENGTH 2 VALUE 'cm', " centimeters
        mm TYPE c LENGTH 2 VALUE 'mm', " meters
      END OF unit_of_measure.

    TYPES:
      t_entities_create TYPE TABLE FOR CREATE zr_header_1405\\Header,
      t_entities_update TYPE TABLE FOR UPDATE zr_header_1405\\Header,
      t_failed_Header   TYPE TABLE FOR FAILED EARLY zr_header_1405\\Header,
      t_reported_Header TYPE TABLE FOR REPORTED EARLY zr_header_1405\\Header.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Header RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Header RESULT result.

    METHODS precheck_create FOR PRECHECK
      IMPORTING entities FOR CREATE Header.

    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE Header.

    METHODS is_create_granted
      RETURNING VALUE(create_granted) TYPE abap_bool.

    METHODS is_update_granted
      RETURNING VALUE(update_granted) TYPE abap_bool.

    METHODS is_delete_granted
      RETURNING VALUE(delete_granted) TYPE abap_bool.

    METHODS precheck_auth
      IMPORTING
        it_entities_create TYPE t_entities_create OPTIONAL
        it_entities_update TYPE t_entities_update OPTIONAL
      CHANGING
        ct_failed          TYPE t_failed_header
        ct_reported        TYPE t_reported_header.

ENDCLASS.

CLASS lhc_Header IMPLEMENTATION.
  METHOD is_create_granted.
    create_granted = abap_true.
  ENDMETHOD.

  METHOD is_update_granted.
    update_granted = abap_true.
  ENDMETHOD.

  METHOD is_delete_granted.
    delete_granted = abap_true.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zr_header_1405 IN LOCAL MODE
         ENTITY Header
         FIELDS ( OrderStatus )
         WITH CORRESPONDING #( keys )
    RESULT DATA(lt_headers)
    FAILED failed.

    result = VALUE #(  FOR ls_header IN lt_headers (
        %tky         = ls_header-%tky
        %assoc-_Item = COND #( WHEN ls_header-OrderStatus = header_status-canceled
                               THEN if_abap_behv=>fc-o-disabled
                               ELSE if_abap_behv=>fc-o-enabled )
                             )
    ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
    DATA: lv_update_requested TYPE abap_boolean,
          lv_delete_requested TYPE abap_boolean,
          lv_update_granted   TYPE abap_boolean,
          lv_delete_granted   TYPE abap_boolean.

    READ ENTITIES OF zr_header_1405 IN LOCAL MODE
         ENTITY Header
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_headers)
         FAILED failed.

    "CHECK lt_headers IS NOT INITIAL.

    lv_update_requested = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on
                                  THEN abap_true
                                  ELSE abap_false ).


    lv_delete_requested = COND #( WHEN requested_authorizations-%delete = if_abap_behv=>mk-on
                                  THEN abap_true
                                  ELSE abap_false ).

    LOOP AT lt_headers INTO DATA(ls_header).
      APPEND VALUE #( LET upd_auth = COND #( WHEN lv_update_granted EQ abap_true
                                             THEN if_abap_behv=>auth-allowed
                                             ELSE if_abap_behv=>auth-unauthorized )

                          del_auth = COND #( WHEN lv_delete_granted EQ abap_true
                                             THEN if_abap_behv=>auth-allowed
                                             ELSE if_abap_behv=>auth-unauthorized )

                      IN %tky         = ls_header-%tky
                         %update      = upd_auth
                         %delete      = del_auth
                    ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.
    IF requested_authorizations-%create EQ if_abap_behv=>mk-on.
      IF is_create_granted(  ) EQ abap_true.
        result-%create = if_abap_behv=>auth-allowed.
      ELSE.
        result-%create = if_abap_behv=>auth-unauthorized.

        APPEND VALUE #( %msg = NEW /dmo/cm_flight_messages(
              textid = /dmo/cm_flight_messages=>not_authorized
              severity = if_abap_behv_message=>severity-error )
              %global = if_abap_behv=>mk-on ) TO reported-header.
      ENDIF.
    ENDIF.

    IF requested_authorizations-%update      EQ if_abap_behv=>mk-on.
      IF is_update_granted(  ) EQ abap_true.
        result-%update = if_abap_behv=>auth-allowed.
      ELSE.
        result-%update = if_abap_behv=>auth-unauthorized.

        APPEND VALUE #( %msg  = NEW /dmo/cm_flight_messages(
                                  textid   = /dmo/cm_flight_messages=>not_authorized
                                  severity = if_abap_behv_message=>severity-error
                                )
                        %global = if_abap_behv=>mk-on
                      ) TO reported-header.
      ENDIF.
    ENDIF.

    IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.
      IF is_create_granted(  ) EQ abap_true.
        result-%delete = if_abap_behv=>auth-allowed.
      ELSE.
        result-%delete = if_abap_behv=>auth-unauthorized.

        APPEND VALUE #( %msg  = NEW /dmo/cm_flight_messages(
                                  textid   = /dmo/cm_flight_messages=>not_authorized
                                  severity = if_abap_behv_message=>severity-error
                                )
                        %global = if_abap_behv=>mk-on
                      ) TO reported-header.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD precheck_create.
    precheck_auth(
       EXPORTING
         it_entities_create = entities
       CHANGING
         ct_failed          = failed-header
         ct_reported        = reported-header
     ).
  ENDMETHOD.

  METHOD precheck_update.
    precheck_auth(
      EXPORTING
        it_entities_update = entities
      CHANGING
        ct_failed          = failed-header
        ct_reported        = reported-header
    ).
  ENDMETHOD.

  METHOD precheck_auth.
    DATA:
      lt_entities          TYPE t_entities_update,
      lv_operation         TYPE if_abap_behv=>t_char01,
      lv_is_modify_granted TYPE abap_bool.

    ASSERT NOT ( it_entities_create IS INITIAL EQUIV it_entities_update IS INITIAL ).

    IF it_entities_create IS NOT INITIAL.

      lt_entities  = CORRESPONDING #( it_entities_create MAPPING %cid_ref = %cid ).
      lv_operation = if_abap_behv=>op-m-create.
    ELSE.

      lt_entities  = it_entities_update.
      lv_operation = if_abap_behv=>op-m-update.
    ENDIF.

    LOOP AT lt_entities INTO DATA(ls_entity).

      lv_is_modify_granted = abap_true.

      CASE lv_operation.
        WHEN if_abap_behv=>op-m-create.

          lv_is_modify_granted = is_create_granted( ).

        WHEN if_abap_behv=>op-m-update.

          lv_is_modify_granted = is_update_granted( ).

      ENDCASE.

      IF lv_is_modify_granted EQ abap_false.

        APPEND VALUE #( %cid = COND #( WHEN lv_operation = if_abap_behv=>op-m-create
                                       THEN ls_entity-%cid_ref )
                                       %tky = ls_entity-%tky
                                       ) TO ct_failed.

        APPEND VALUE #( %cid = COND #( WHEN lv_operation = if_abap_behv=>op-m-create
                                       THEN ls_entity-%cid_ref )
                                       %tky = ls_entity-%tky ) TO ct_reported.


      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
