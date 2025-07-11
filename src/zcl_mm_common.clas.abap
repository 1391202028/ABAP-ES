CLASS zcl_mm_common DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    CLASS-METHODS: create_material_document
      CHANGING cs_mdoc TYPE zsmm_mdoc_main.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mm_common IMPLEMENTATION.
  METHOD create_material_document.
    DATA:lt_item   TYPE TABLE FOR CREATE i_materialdocumenttp\_MaterialDocumentItem,
         ls_item   LIKE LINE OF lt_item,
         ls_target LIKE LINE OF ls_item-%target.
    DATA:lv_gmcode             TYPE zsmm_mdoc_item-goodsmovementtype,
         lv_GoodsMovementType  TYPE zsmm_mdoc_item-GoodsMovementType,
         lv_purchaseorder      TYPE zsmm_mdoc_item-purchaseorder,
         lv_ManufacturingOrder TYPE zsmm_mdoc_item-manufacturingorder.
    LOOP AT cs_mdoc-item ASSIGNING FIELD-SYMBOL(<fs_item>).
      IF <fs_item>-goodsmovementtype BETWEEN '101' AND '102'.
        IF ( <fs_item>-purchaseorder IS INITIAL OR <fs_item>-purchaseorderitem IS INITIAL ) AND <fs_item>-manufacturingorder IS INITIAL.
          <fs_item>-messagetype = 'E'.
          <fs_item>-message = '采购订单或生产订单不可同时为空'.
        ENDIF.
      ENDIF.
      IF <fs_item>-goodsmovementtype BETWEEN '103' AND '106' OR <fs_item>-goodsmovementtype = '122' OR <fs_item>-goodsmovementtype = '123'
        OR <fs_item>-goodsmovementtype = '161' OR <fs_item>-goodsmovementtype = '162'.
        IF <fs_item>-purchaseorder IS INITIAL OR <fs_item>-purchaseorderitem IS INITIAL.
          <fs_item>-messagetype = 'E'.
          <fs_item>-message = '采购订单或行项目号不可为空'.
        ENDIF.
      ENDIF.
      ls_target-Plant = <fs_item>-plant."工厂
      ls_target-material = |{ <fs_item>-material ALPHA = IN WIDTH = 18 }|."物料
      ls_target-GoodsMovementType = <fs_item>-goodsmovementtype."移动类型
      ls_target-StorageLocation = <fs_item>-storagelocation."库存地点
      ls_target-QuantityInEntryUnit = <fs_item>-quantityinentryunit."数量
      ls_target-EntryUnit = <fs_item>-entryunit."单位
      ls_target-InventorySpecialStockType = <fs_item>-inventoryspecialstocktype."特殊库存类型
      ls_target-ManufacturingOrder = |{ <fs_item>-manufacturingorder ALPHA = IN WIDTH = 12 }|."生产订单
      ls_target-ManufacturingOrderItem = <fs_item>-manufacturingorderitem."生产订单行项目
      ls_target-ManufactureDate = <fs_item>-manufacturedate."生产日期
      ls_target-Reservation = <fs_item>-reservation."预留号
      ls_target-ReservationItem = <fs_item>-reservationitem."预留行号
      ls_target-PurchaseOrder = <fs_item>-purchaseorder."采购订单
      ls_target-PurchaseOrderItem = <fs_item>-purchaseorderitem."采购订单行号
      ls_target-IssuingOrReceivingPlant = <fs_item>-issuingorreceivingplant."接收工厂
      ls_target-IssuingOrReceivingStorageLoc = <fs_item>-issuingorreceivingstorageloc."接收库存地点
      ls_target-IssgOrRcvgMaterial = <fs_item>-issgorrcvgmaterial."接收物料
      ls_target-IssgOrRcvgBatch = <fs_item>-issgorrcvgbatch."接收批次
      ls_target-GoodsMovementRefDocType = COND #( WHEN <fs_item>-purchaseorder IS NOT INITIAL THEN 'B'
                                                  WHEN <fs_item>-manufacturingorder IS NOT INITIAL THEN
                                                  COND #( WHEN <fs_item>-reservation IS NOT INITIAL THEN ''
                                                          ELSE COND #( WHEN <fs_item>-goodsmovementtype = '262' THEN ''
                                                                       ELSE 'F') ) ).   "移动标识
      ls_target-%control-plant = cl_abap_behv=>flag_changed.
      ls_target-%control-material = cl_abap_behv=>flag_changed.
      ls_target-%control-GoodsMovementType = cl_abap_behv=>flag_changed.
      ls_target-%control-storagelocation = cl_abap_behv=>flag_changed.
      ls_target-%control-QuantityInEntryUnit = cl_abap_behv=>flag_changed.
      ls_target-%control-entryunit = cl_abap_behv=>flag_changed.
      APPEND ls_target TO ls_item-%target.
      CLEAR:ls_target.
      lv_goodsmovementtype = <fs_item>-goodsmovementtype.
      lv_purchaseorder = <fs_item>-purchaseorder.
      lv_manufacturingorder = <fs_item>-manufacturingorder.
    ENDLOOP.
    ls_item-%cid_ref = 'CID_001'.
    APPEND ls_item TO lt_item.
    CASE lv_goodsmovementtype.
      WHEN '201' OR '202'.
        lv_gmcode = '03'.
      WHEN '311' OR '312' OR '313' OR '314' OR '315' OR '316' OR '541' OR '542'.
        lv_gmcode = '04'.
      WHEN '701' OR '702' OR '561' OR '562' OR '501' OR 'Z01' OR 'Z02' OR '502'.
        lv_gmcode = '05'.
      WHEN '261' OR '262'.
        lv_gmcode = '03'.
      WHEN '101' OR '102'.
        lv_gmcode = COND #( WHEN lv_purchaseorder IS NOT INITIAL THEN '01'
                            WHEN lv_manufacturingorder IS NOT INITIAL THEN '02' ).
    ENDCASE.
    MODIFY ENTITIES OF i_materialdocumenttp
    ENTITY MaterialDocument
    CREATE FROM VALUE #( ( %cid = 'CID_001'
                           goodsmovementcode =  lv_gmcode "过账码
                           postingdate = cs_mdoc-postingdate "过账日期
                           documentdate = cs_mdoc-documentdate "凭证日期
                           MATERIALDOCUMENTheadertext = cs_mdoc-materialdocumentheadertext "抬头文本
                           CREATEdbyuser = cs_mdoc-createdbyuser "创建人
                           referencedocument = cs_mdoc-referencedocument "参考凭证
                           %control-goodsmovementcode = cl_abap_behv=>flag_changed
                           %control-postingdate = cl_abap_behv=>flag_changed
                           %control-documentdate = cl_abap_behv=>flag_changed
                           %control-MATERIALDOCUMENTheadertext = cl_abap_behv=>flag_changed ) )
    ENTITY MaterialDocument
    CREATE BY \_MaterialDocumentItem
    AUTO FILL CID WITH lt_item[]
    MAPPED DATA(ls_create_mapped)
    FAILED DATA(ls_create_failed)
    REPORTED DATA(ls_create_reported).

    COMMIT ENTITIES BEGIN
   RESPONSE OF i_materialdocumenttp
    FAILED DATA(commit_failed)
    REPORTED DATA(commit_reported).
    IF COMMIT_failed IS INITIAL.
      LOOP AT ls_create_mapped-materialdocument ASSIGNING FIELD-SYMBOL(<keys_header>).

        CONVERT KEY OF i_materialdocumentTp
        FROM <keys_header>-%pid
        TO <keys_header>-%key.
      ENDLOOP.
      IF sy-subrc = 0.
        IF ls_create_mapped-materialdocument[ 1 ]-MaterialDocument IS NOT INITIAL.
          cs_mdoc-materialdocument = ls_create_mapped-materialdocument[ 1 ]-MaterialDocument.
          cs_mdoc-materialdocumentyear = ls_create_mapped-materialdocument[ 1 ]-MaterialDocumentYear.
          cs_mdoc-messagetype = 'S'.
          cs_mdoc-message = '物料凭证' && cs_mdoc-materialdocument && '年度' && cs_mdoc-materialdocumentyear && '创建成功'.
        ENDIF.
      ENDIF.
    ELSE.
      LOOP AT commit_reported-materialdocumentitem INTO DATA(ls_report).
        cs_mdoc-message = cs_mdoc-message && ls_report-%msg->if_message~get_longtext( ).
      ENDLOOP.
      cs_mdoc-messagetype = 'E'.
      cs_mdoc-message = '物料凭证创建失败，原因为:' && cs_mdoc-message.
    ENDIF.
    COMMIT ENTITIES END.

  ENDMETHOD.

ENDCLASS.
