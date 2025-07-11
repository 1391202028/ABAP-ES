CLASS zcltest_gw DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltest_gw IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    "交货单操作
*    MODIFY ENTITIES OF I_OutboundDeliveryTP
*   ENTITY OutboundDelivery
*   CREATE BY \_Item
*   FROM VALUE #( ( %tky = VALUE #( OutboundDelivery = '0080000038' )
*   %target = VALUE #(
*   %control = VALUE #( Material = if_abap_behv=>mk-on
*   ActualDeliveredQtyInOrderUnit = if_abap_behv=>mk-on )
*   ( %cid = 'I001'
*   Material = 'SG9100'
*   ActualDeliveredQtyInOrderUnit = '6'
*   batch = '0000000012'
*   HigherLevelItem = '000010'
*   HigherLvlItmOfBatSpltItm = '000010'
*   Plant = '1310'
*   StorageLocation = '131B'
*   outbounddelivery = '0080000038'
*   OrderQuantityUnit = 'L' ) ) ) )
*   MAPPED DATA(ls_mapped)
*   REPORTED DATA(ls_reported)
*   FAILED DATA(ls_failed).
*    COMMIT ENTITIES.

    "COMMIT ENTITIES RESPONSE OF I_OutboundDeliveryTP into DATA(lt_response)
    "               FAILED I_OutboundDeliveryTP INTO DATA(lt_fail).
    "
*"物料凭证操作：Begin
*    MODIFY ENTITIES OF i_materialdocumenttp
* ENTITY MaterialDocument
* CREATE FROM VALUE #( ( %cid = 'CID_001'
* goodsmovementcode = '02'
*
* postingdate = '20250616'
* documentdate = '20250616'
* %control-goodsmovementcode = cl_abap_behv=>flag_changed
* %control-postingdate = cl_abap_behv=>flag_changed
* %control-documentdate = cl_abap_behv=>flag_changed
* ) )
* ENTITY MaterialDocument
* CREATE BY \_MaterialDocumentItem
* FROM VALUE #( (
* %cid_ref = 'CID_001'
* %target = VALUE #( ( %cid = 'CID_ITM_001'
* plant = '1310'
* material = |{ '17' ALPHA = IN width = 18 }|
* GoodsMovementType = '101'
* storagelocation = '131B'
* manufacturingorder = |{ '1000023' ALPHA = IN width = 12 }|
* ManufacturingOrderItem = '1'
* GoodsMovementRefDocType = 'F'
* QuantityInEntryUnit = 1
* entryunit = 'KG'
* %control-plant = cl_abap_behv=>flag_changed
* %control-material = cl_abap_behv=>flag_changed
* %control-GoodsMovementType = cl_abap_behv=>flag_changed
* %control-storagelocation = cl_abap_behv=>flag_changed
* %control-QuantityInEntryUnit = cl_abap_behv=>flag_changed
* %control-entryunit = cl_abap_behv=>flag_changed
* ) )
*
*
* ) )
* MAPPED DATA(ls_create_mapped)
* FAILED DATA(ls_create_failed)
* REPORTED DATA(ls_create_reported).
*    out->write( '12' ).
*    COMMIT ENTITIES BEGIN
*   RESPONSE OF i_materialdocumenttp
*    FAILED DATA(commit_failed)
*    REPORTED DATA(commit_reported).
*
*    LOOP AT ls_create_mapped-materialdocument ASSIGNING FIELD-SYMBOL(<keys_header>).
*
*      CONVERT KEY OF i_materialdocumentTp
*      FROM <keys_header>-%pid
*      TO <keys_header>-%key.
*    ENDLOOP.
**
*    LOOP AT ls_create_mapped-materialdocumentitem ASSIGNING FIELD-SYMBOL(<keys_item>).
*
*      CONVERT KEY OF i_materialdocumentitemtp
*      FROM <keys_item>-%pid
*      TO <keys_item>-%key.
*    ENDLOOP.
*
*    COMMIT ENTITIES END.
*    "物料凭证操作：End
    "物料凭证创建 Begin
*    DATA:ls_mdoc TYPE zsmm_mdoc_main,
*         ls_item TYPE ZSMM_MDOC_item,
*         lt_item TYPE ztmm_mdoc_item.
*    ls_mdoc-documentdate = '20250617'.
*    ls_mdoc-postingdate = '20250617'.
*    ls_mdoc-materialdocumentheadertext = 'test'.
*    ls_mdoc-createdbyuser = 'test'.
*    ls_mdoc-referencedocument = 'test-001'.
*    ls_item-goodsmovementtype = '101'.
*    ls_item-storageLocation = '131B'.
*    ls_item-plant = '1310'.
*    ls_item-material = '17'.
*    ls_item-manufacturingorder = '1000023'.
*    ls_item-manufacturingorderitem = '1'.
*    ls_item-quantityinentryunit = '1'.
*    ls_item-entryunit = 'KG'.
*    APPEND ls_item TO LS_MDOC-item.
*    zcl_mm_common=>create_material_document(
*      CHANGING
*        cs_mdoc = ls_mdoc
*    ).
**    CALL FUNCTION 'ZFMMM001'
**      CHANGING
**        cs_mdoc = ls_mdoc.
*     out->write( ls_mdoc-materialdocument ).
*     out->write( ls_mdoc-materialdocumentyear ).
*     out->write( ls_mdoc-messagetype ).
*     out->write( ls_mdoc-message ).
    "物料凭证创建 End
    "生产订单组件操作 Begin
*    DATA:lt_operationcomponent TYPE TABLE FOR CREATE I_ProductionOrderOperationTP\_OperationComponent,
*         ls_operationcomponent LIKE LINE OF lt_operationcomponent.
*    DATA:lt_component          like TABLE FOR CREATE LS_OPERATIONCOMPONENT-%target,
*         ls_component like LINE OF lt_component.
*    "ls_component          LIKE LINE OF  lt_component.
*    ls_operationcomponent-%key-OrderInternalID = '0000001161'.
*   " LT_COMPONENT = VALUE #( %data-material = |{ '289213' ALPHA = IN WIDTH = 18 }|  ).
*    MODIFY ENTITIES OF i_productionordertp
*    ENTITY productionorderoperation
*    CREATE BY \_operationcomponent
*    AUTO FILL CID
*    FIELDS ( material
*             billofmaterialitemcategory
*             requiredquantity
*             baseunit )
*    WITH VALUE #(
*         ( %key-orderinternalid = '0000001161'
*           %key-orderoperationinternalid = '00000001'
*           %target = VALUE #(
*           ( material = |{ '2' ALPHA = IN WIDTH = 18 }|
*             %data-billofmaterialitemcategory = 'L'
*             %data-requiredquantity = 22
*             %data-baseunit = 'KG'
*             %data-StorageLocation = '131A' )
*                            )
*         )
*                )
*    FAILED DATA(failed)
*    REPORTED DATA(reported)
*    MAPPED DATA(mapped).
*
*    IF failed IS INITIAL.
*      COMMIT ENTITIES
*      RESPONSES
*      FAILED DATA(failed_commit)
*      REPORTED DATA(reported_commit).
*    ELSE.
*      ROLLBACK ENTITIES.
*    ENDIF.

    "生产订单组件操作 End
 " DATA(lv_str) =  cl_sec_sxml_writer=>

*  MODIFY ENTITIES OF i_productionordertp
* ENTITY productionordercomponent
* EXECUTE delete
* FROM VALUE #(
* (
* %key-reservation = '0000001455'
* %key-reservationitem = '0001'
* %key-reservationrecordtype = ''
* )
** (
** %key-reservation = '0000000407'
** %key-reservationitem = '0002'
** %key-reservationrecordtype = ''
** )
* )
* RESULT DATA(result)
* FAILED DATA(failed)
* REPORTED DATA(reported).
*
* IF failed IS INITIAL.
* COMMIT ENTITIES
* RESPONSES
* FAILED DATA(failed_commit)
* REPORTED DATA(reported_commit).
* ELSE.
* ROLLBACK ENTITIES.
* ENDIF.
MODIFY ENTITIES OF I_ProductionOrderTP
 ENTITY productionorderitem
 EXECUTE delete
 FROM VALUE #( ( %key-productionorder = '000001001153'
 %key-productionorderitem = '0003'
 )
 )
 RESULT FINAL(result)
 FAILED FINAL(failed)
 REPORTED FINAL(reported).

 IF failed IS INITIAL.
 COMMIT ENTITIES
 RESPONSES
 FAILED DATA(failed_commit)
 REPORTED DATA(reported_commit).
 ELSE.
 ROLLBACK ENTITIES.
 ENDIF.
  ENDMETHOD.
ENDCLASS.

