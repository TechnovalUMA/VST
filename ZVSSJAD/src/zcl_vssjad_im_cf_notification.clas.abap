CLASS zcl_vssjad_im_cf_notification DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES /dbe/if_cf_enh_notification .
    INTERFACES if_badi_interface .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_vss_order
      IMPORTING
        !iv_vbeln          TYPE /dbe/vbeln_va
      RETURNING
        VALUE(ro_instance) TYPE REF TO /dbe/cl_order .
    METHODS get_plant_addr
      IMPORTING
        !iv_werks    TYPE werks_d
      EXPORTING
        !ev_addr1    TYPE clike
        !ev_addr2    TYPE clike
        !ev_phone_no TYPE clike
        !ev_email    TYPE clike .
    METHODS get_jobs_fragment
      IMPORTING
        !io_order TYPE REF TO /dbe/cl_order
      EXPORTING
        !ev_frg   TYPE string .
    METHODS get_atta_fragment
      IMPORTING
        !io_task TYPE REF TO /dbe/cl_cf_a_task
      EXPORTING
        !ev_frg  TYPE string .
    METHODS get_job_confirmation_url
      IMPORTING
        !iv_message   TYPE /dbe/ars_camtr-message_id_inp
        !io_order     TYPE REF TO /dbe/cl_order
        !iv_jobnr     TYPE /dbe/vbap-jobs
      RETURNING
        VALUE(rv_url) TYPE string.

ENDCLASS.



CLASS ZCL_VSSJAD_IM_CF_NOTIFICATION IMPLEMENTATION.


  METHOD /dbe/if_cf_enh_notification~execute_action.
  ENDMETHOD.


  METHOD /dbe/if_cf_enh_notification~get_parameters.
    DATA: ls_context LIKE LINE OF is_notif_ins-context,
          ls_job     LIKE LINE OF /dbe/cl_order=>mt_job_com,
          lo_order   TYPE REF TO /dbe/cl_order,
          ls_item    LIKE LINE OF lo_order->mt_vbap_com,
          lv_items   TYPE string.
    DATA: lv_dummy(30)  TYPE c,
          lv_dummy1(30) TYPE c.
    CASE is_notif_ins-notif_id.

      WHEN 'VSS-JOB-REQ-CUST-APPRO'.
        lo_order = get_vss_order( iv_vbeln = CONV #( is_notif_ins-srcob_id-srcob_key ) ).
        "   DATA(lo_task) = /dbe/cl_cf_task_api=>get_task( iv_uid = is_notif_ins-its_uid ).
        READ TABLE is_notif_ins-context INTO ls_context WITH KEY name = '/DBE/JOBNR'.
        IF sy-subrc = 0 AND lo_order IS BOUND.
          ls_job-jobnr = ls_context-value.
          READ TABLE lo_order->mt_job_com INTO ls_job WITH KEY jobnr  = ls_job-jobnr.
          IF sy-subrc = 0.
            WRITE ls_job-j_brtwr TO lv_dummy CURRENCY ls_job-waerk.
            TRY.
                ct_parameter[ name = 'cost' ]-value = lv_dummy.
                ct_parameter[ name = 'currency' ]-value = ls_job-waerk.
                ct_parameter[ name = 'lic_plate' ]-value = lo_order->ms_header_detail-licpl.
                ct_parameter[ name = 'job_description' ]-value = ls_job-descr1 && ls_job-descr2 && ls_job-descr3 && ls_job-descr4.
                ct_parameter[ name = 'confirm_url' ]-value = get_job_confirmation_url( io_order = lo_order iv_jobnr = ls_job-jobnr iv_message =
                zcl_vssjad_a_ord_job_conf_api=>c_message_job_confirm ).
                ct_parameter[ name = 'defer_url' ]-value = get_job_confirmation_url( io_order = lo_order iv_jobnr = ls_job-jobnr iv_message =
                zcl_vssjad_a_ord_job_conf_api=>c_message_job_defer ).
                ct_parameter[ name = 'reject_url' ]-value = get_job_confirmation_url( io_order = lo_order iv_jobnr = ls_job-jobnr iv_message =
                zcl_vssjad_a_ord_job_conf_api=>c_message_job_reject ).
              CATCH cx_sy_itab_line_not_found.
            ENDTRY.
          ENDIF.
        ENDIF.
        READ TABLE is_notif_ins-context INTO ls_context WITH KEY name = '@TEXT'.
        TRY.
            IF sy-subrc = 0.

              ct_parameter[ name = 'message_note' ]-value = ls_context-value.
            ENDIF.


            get_plant_addr( EXPORTING iv_werks    = lo_order->ms_vbak_com-werks
                            IMPORTING ev_addr1    = ct_parameter[ name = 'wrk_addr_line2' ]-value
                                      ev_addr2    = ct_parameter[ name = 'wrk_addr_line3' ]-value
                                      ev_email    = ct_parameter[ name = 'wrk_addr_email' ]-value
                                      ev_phone_no = ct_parameter[ name = 'wrk_addr_phone_no' ]-value ).

            get_jobs_fragment( EXPORTING io_order = lo_order
                               IMPORTING ev_frg   = ct_parameter[ name = 'frg_job_list' ]-value ).

          CATCH cx_sy_itab_line_not_found.
        ENDTRY.


*        get_atta_fragment( EXPORTING io_task = lo_task
*                           IMPORTING ev_frg   = ct_parameter[ name = 'frg_attachment_list' ]-value ).
*
      WHEN 'VSS-JOB-REQ-PARTS'.
        lo_order = get_vss_order( iv_vbeln = CONV #( is_notif_ins-srcob_id-srcob_key ) ).
        READ TABLE is_notif_ins-context INTO ls_context WITH KEY name = '/DBE/JOBNR'.
        ls_job-jobnr = ls_context-value.
        WRITE ls_job-jobnr TO lv_dummy.
        TRY.
            ct_parameter[ name = 'job_number' ]-value = lv_dummy.
            IF sy-subrc = 0 AND lo_order IS BOUND.
              READ TABLE lo_order->mt_job_com INTO ls_job WITH KEY jobnr  = ls_job-jobnr.
              IF sy-subrc = 0.
                ct_parameter[ name = 'job_description' ]-value = ls_job-descr1 && ls_job-descr2 && ls_job-descr3 && ls_job-descr4.
                ct_parameter[ name = 'logo_base64' ]-value = zcl_vssjad_a_ord_job_conf_api=>get_logo_base64( ).
                LOOP AT lo_order->mt_vbap_com INTO ls_item WHERE jobs = ls_job-jobnr.
                  CHECK lo_order->mo_status->get_item( iv_action = 'GDSMVT_CREATE' iv_posnr  = ls_item-posnr ) CA 'AB'.


                  WRITE ls_item-zmeng TO lv_dummy UNIT ls_item-zieme.
                  WRITE ls_item-zieme TO lv_dummy1.
                  lv_items = lv_items && '<tr><td>'
                  && ls_item-matnr40 && '</td><td>'
                  && ls_item-arktx && '</td><td style="text-align: right;">'
                  && lv_dummy  && '&nbsp</td><td style="text-align: center;">'
                  && lv_dummy1
                  && '</td></tr>'.
                ENDLOOP.
                ct_parameter[ name = 'parts' ]-value = lv_items.
              ENDIF.
            ENDIF.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.

    ENDCASE.
  ENDMETHOD.


  METHOD /dbe/if_cf_enh_notification~prepare_notification.
  ENDMETHOD.


  METHOD get_atta_fragment.

    DATA:
      lv_template TYPE string,
      lv_cid      TYPE hash160,
      lt_param    TYPE /dbe/cl_cf_notif_api=>typ_t_param_value.

    /dbe/cl_cf_x_tools=>read_smtg_template( EXPORTING iv_tmpl_id   = 'ZDBE_CF_ORD_CONF_ATTA_ITEM'
                                            IMPORTING ev_body_html = lv_template ).

    DATA(lt_atta) = io_task->attachment_get( iv_mimetype = 'image/*' ).

    LOOP AT lt_atta ASSIGNING FIELD-SYMBOL(<ls_atta>).
      CALL FUNCTION 'CALCULATE_HASH_FOR_CHAR'
        EXPORTING
          data = CONV string( <ls_atta>-instid )
        IMPORTING
          hash = lv_cid.

      lt_param = VALUE #(
        ( name = 'attachment_cid' value = lv_cid )
      ).
      DATA(lv_frg) = /dbe/cl_cf_notif_api=>replace_params_in_text( iv_content = lv_template it_parameter = lt_param ).
      CONCATENATE ev_frg lv_frg cl_abap_char_utilities=>cr_lf INTO ev_frg.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_jobs_fragment.

    DATA:
      lv_template TYPE string,
      lt_param    TYPE /dbe/cl_cf_notif_api=>typ_t_param_value.

    /dbe/cl_cf_x_tools=>read_smtg_template( EXPORTING iv_tmpl_id   = 'ZDBE_CF_ORD_CONF_JOB_ITEM'
                                            IMPORTING ev_body_html = lv_template ).

    LOOP AT io_order->mt_job_com ASSIGNING FIELD-SYMBOL(<ls_job_com>) WHERE jobnr <> '000000' AND rejected IS INITIAL.
      lt_param = VALUE #(
        ( name = 'job_desc'      value = <ls_job_com>-descr1 )
        ( name = 'job_type'      value = <ls_job_com>-job_type )
        ( name = 'job_type_desc' value = <ls_job_com>-job_type_bezei )
      ).
      DATA(lv_frg) = /dbe/cl_cf_notif_api=>replace_params_in_text( iv_content = lv_template it_parameter = lt_param ).
      CONCATENATE ev_frg lv_frg cl_abap_char_utilities=>cr_lf INTO ev_frg.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_job_confirmation_url.
    DATA: lv_icfnodguid TYPE icfservice-icfnodguid,
          lv_host       TYPE string,
          lv_port       TYPE string,
          lv_hostnumber TYPE i,
          lv_url_serv   TYPE icfurlbuf.



    DATA lv_aliasname TYPE icfalias-icfalias.
    lv_aliasname =  '/zvssjad' && sy-mandt.
    SELECT SINGLE icfalias, icfaliguid FROM icfalias WHERE lower( icfalias ) = @lv_aliasname INTO ( @lv_url_serv, @lv_icfnodguid ).
    IF sy-subrc = 0.
      CALL FUNCTION 'HTTP_GET_URL_FROM_NODGUID'
        EXPORTING
          nodguid     = lv_icfnodguid
        IMPORTING
*         url         = lv_url_serv
          host_number = lv_hostnumber
*         HOST_NAME   =
*         EXTENDED_URL       =
        EXCEPTIONS
          icf_inconst = 1
          OTHERS      = 2.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
      lv_url_serv = lv_aliasname+1 && '/'.
    ELSE.
      SELECT SINGLE icfnodguid FROM icfservice INTO lv_icfnodguid
        WHERE icf_name = 'ZVSSJAD'.                        "#EC WARN_OK
      CALL FUNCTION 'HTTP_GET_URL_FROM_NODGUID'
        EXPORTING
          nodguid     = lv_icfnodguid
        IMPORTING
          url         = lv_url_serv
          host_number = lv_hostnumber
*         HOST_NAME   =
*         EXTENDED_URL       =
        EXCEPTIONS
          icf_inconst = 1
          OTHERS      = 2.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'TH_GET_VIRT_HOST_DATA'
      EXPORTING
        protocol       = 2
        virt_idx       = lv_hostnumber
*       LOCAL          = 1
      IMPORTING
        hostname       = lv_host
        port           = lv_port
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

*Concatenate Url
    CONCATENATE 'https://' lv_host ':' lv_port '/' lv_url_serv
                iv_message '?v=' io_order->ms_vbak_com-vbeln
                '&g=' io_order->ms_vbak_com-vguid
                '&j=' iv_jobnr
                '&sap-client=' sy-mandt
                INTO rv_url.

  ENDMETHOD.


  METHOD get_plant_addr.

    DATA:
      lv_adrnr TYPE adrnr.

    CLEAR: ev_addr1, ev_addr2, ev_phone_no, ev_email.

    SELECT SINGLE adrnr FROM t001w
      INTO lv_adrnr
      WHERE werks = iv_werks.

    CHECK sy-subrc = 0 AND lv_adrnr IS NOT INITIAL.

    /dbme/wma_cl_x_util=>read_address_data(
      EXPORTING
        iv_adrnr      = lv_adrnr
        iv_phone_long = abap_true
      IMPORTING
        es_data       = DATA(ls_addr) ).

    ev_email = ls_addr-email_addr.
    ev_phone_no = ls_addr-tel_number.
    CONCATENATE ls_addr-street ls_addr-house_num ls_addr-house_num2 INTO ev_addr1 SEPARATED BY space.
    CONDENSE ev_addr1.
    CONCATENATE ls_addr-post_code ls_addr-city INTO ev_addr2 SEPARATED BY space.
    CONDENSE ev_addr2.

  ENDMETHOD.


  METHOD get_vss_order.

    DATA:
      lo_order       TYPE REF TO /dbe/cl_order,
      ls_dialog_ctrl TYPE /dbe/oe_dialog_control.

    ls_dialog_ctrl-actvt = '03'.
    CALL FUNCTION '/DBE/OE_MAIN_GET'
      EXPORTING
        iv_vbeln          = iv_vbeln
        is_dialog_control = ls_dialog_ctrl
      IMPORTING
        eo_order          = lo_order
      EXCEPTIONS
        internal_error    = 1
        nothing_selected  = 2
        action_error      = 3
        OTHERS            = 4.
    IF sy-subrc = 0.
      ro_instance = lo_order.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
