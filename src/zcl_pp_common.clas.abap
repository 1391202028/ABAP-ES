"! <p class="shorttext synchronized" lang="en">PP Common method</p>
CLASS zcl_pp_common DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: create_production_order,
      maintain_prd_ord_component CHANGING is_data TYPE zspp_prd_ord_op_component_main.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_pp_common IMPLEMENTATION.
  METHOD create_production_order.

  ENDMETHOD.

  METHOD maintain_prd_ord_component.
*  DATA:lt_delete TYPE TABLE FOR create i_productionordertp\.
*    MODIFY ENTITIES OF i_productionordertp
*   ENTITY productionordercomponent
*   EXECUTE delete
*   FROM
*   VALUE #(
*   ( %key-reservation = '0000001455'
*     %key-reservationitem = '0001'
*     %key-reservationrecordtype = '' )
*
*   )
*    FAILED DATA(failed)
*    REPORTED DATA(reported)
*    MAPPED DATA(mapped)
*   RESULT DATA(result)
*   FAILED DATA(failed)
*   REPORTED DATA(reported)
*.
*
*    IF failed IS INITIAL.
*      COMMIT ENTITIES
*      RESPONSES
*      FAILED DATA(failed_commit)
*      REPORTED DATA(reported_commit).
*    ELSE.
*      ROLLBACK ENTITIES.
*    ENDIF.
  ENDMETHOD.

ENDCLASS.
