CLASS zcl_rest_handle DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA:gv_input  TYPE string,
         gv_output TYPE string.
    INTERFACES if_http_service_extension .
    METHODS:handle_xndsj.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rest_handle IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.
    DATA(lv_type) =  request->get_header_field( 'BUSTYPE' ).
    gv_input = request->get_text( ).
    CASE lv_type.
      WHEN 'INTERFACECODE'.
        me->handle_xndsj( ).
    ENDCASE.

    response->set_status( i_code = 200 i_reason = 'OK' ).
    CALL METHOD response->set_text
      EXPORTING
        i_text = me->gv_output.

    CALL METHOD response->set_content_type
      EXPORTING
        content_type = 'application/json'.
  ENDMETHOD.
  METHOD handle_xndsj.
    TYPES:BEGIN OF ty_return,
            message      TYPE string,
            message_type TYPE msgty,
          END OF ty_return.
    DATA:ls_return TYPE ty_return.
    DATA(ls_pretty) = /ui2/cl_json=>pretty_mode-camel_case.
    "/ui2/cl_json=>deserialize( EXPORTING json = CONV #( me->gv_input ) CHANGING  data = lt_data ).
    gv_output = /ui2/cl_json=>serialize( data = ls_return pretty_name = ls_pretty ).
  ENDMETHOD.

ENDCLASS.
