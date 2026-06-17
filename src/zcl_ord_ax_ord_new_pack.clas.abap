class ZCL_ORD_AX_ORD_NEW_PACK definition
  public
  final
  create public .

public section.

  interfaces /DBE/IF_OE_ACTION_EXE .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ORD_AX_ORD_NEW_PACK IMPLEMENTATION.


  METHOD /dbe/if_oe_action_exe~execution.
    " Basant Hamed... 19.11.2023... Default order creation with package
    "in case of order creation from pm notification


    DATA: lo_order       TYPE REF TO /DBE/cl_order,
          ls_item_detail TYPE /dbe/s_pos,
          l_not          TYPE viqmel,
          lpack_id TYPE /DBE/PACKAGE_ID,
          lpack_guid TYPE /DBE/PACK_GUID,
          lpack_pstyv TYPE /DBE/PSTYV,
          lpack_itcat TYPE /DBE/ITEM_CATEGORY.


    lo_order ?= io_ord_object.
    "Parameter ID is passed on FM /DBE/CU14_AC_CRE_ORD enhancement  ZVSS_DEFAULT_PACK.
    IMPORT p1 = l_not FROM MEMORY ID 'NOTIFICATION'.
    CHECK l_not-plnnr IS NOT INITIAL AND l_not-plnal IS NOT INITIAL.

    "" Mapping Tasklists with the packages
    SELECT SINGLE z~package_id z~itcat z~pstyv p~guid
      FROM zvss_tsklst_pack AS z JOIN /dbe/pack_h AS p ON p~package_id = z~package_id
       INTO (lpack_id, lpack_itcat, lpack_pstyv, lpack_guid)
       WHERE plnnr = l_not-plnnr AND
      plnal = l_not-plnal AND datub > sy-datum.


    IF lpack_id IS NOT INITIAL.

      ls_item_detail-pstyv = lpack_pstyv." '0012'.
      ls_item_detail-itcat = lpack_itcat."'P012'.
      ls_item_detail-package_guid = lpack_guid."`051MhTCP7kwUgVthgafrn0`.
      ls_item_detail-package_id = lpack_id."`00000000000000000092`.
     ls_item_detail-itobjid = lpack_id.
      APPEND ls_item_detail TO lo_order->mt_item_detail.

      CALL FUNCTION '/DBE/ORD_INT_ITEM_CHANGE'
        EXPORTING
          iv_action      = 'ITEM_NEW'
          io_order       = Lo_order
        EXCEPTIONS
          internal_error = 1
          nothing_done   = 2
          OTHERS         = 3.
    ENDIF.

    FREE MEMORY ID 'NOTIFICATION'.
  ENDMETHOD.
ENDCLASS.
