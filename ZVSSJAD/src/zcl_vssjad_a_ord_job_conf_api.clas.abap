CLASS zcl_vssjad_a_ord_job_conf_api DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES /dbe/if_ars_e_http_handler .
    CONSTANTS c_message_job_confirm TYPE /dbe/ars_camtr-message_id_inp VALUE 'JOB_CONFIRM' ##NO_TEXT.
    CONSTANTS c_message_job_defer TYPE /dbe/ars_camtr-message_id_inp VALUE 'JOB_DEFER' ##NO_TEXT.
    CONSTANTS c_message_job_defer_conf TYPE /dbe/ars_camtr-message_id_inp VALUE 'JOB_DEFER_CONF' ##NO_TEXT.
    CONSTANTS c_message_job_reject TYPE /dbe/ars_camtr-message_id_inp VALUE 'JOB_REJECT' ##NO_TEXT.
    CONSTANTS c_message_job_reject_conf TYPE /dbe/ars_camtr-message_id_inp VALUE 'JOB_REJECT_CONF' ##NO_TEXT.
    CONSTANTS c_message_job_conf_request TYPE /dbe/ars_camtr-message_id_inp VALUE 'ZVSSJAD_JOB_CONF_REQUEST' ##NO_TEXT.
    CLASS-METHODS get_logo_base64 RETURNING VALUE(rv_logo) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ts_input,
        vbeln      TYPE /dbe/vbak_db-vbeln,
        vguid      TYPE /dbe/vbak_db-vguid,
        jobnr      TYPE /dbe/vbap-jobs,
        follow_up  TYPE /dbe/job-follow_up,
        rej_reason TYPE tvagt-bezei,
      END OF ts_input .
    TYPES:
      BEGIN OF ts_rej_reason,
        abgru TYPE tvag-abgru,
        desc  TYPE tvagt-bezei,
      END OF ts_rej_reason,
      tt_rej_reason TYPE STANDARD TABLE OF ts_rej_reason WITH KEY abgru.


    DATA mo_order TYPE REF TO /dbe/cl_order .
    DATA mv_dummy TYPE string .

    METHODS main_confirm_job
      IMPORTING
                !io_log        TYPE REF TO /dbe/cl_ars_x_log
                !iv_vbeln      TYPE /dbe/vbak_db-vbeln
                !iv_vguid      TYPE /dbe/vbak_db-vguid
                !iv_jobnr      TYPE /dbe/vbap-jobs
      RETURNING VALUE(rv_body) TYPE string
      RAISING
                /dbe/cx_ars_exception.


    METHODS main_defer_job
      IMPORTING
                !io_log        TYPE REF TO /dbe/cl_ars_x_log
                !iv_vbeln      TYPE /dbe/vbak_db-vbeln
                !iv_vguid      TYPE /dbe/vbak_db-vguid
                !iv_jobnr      TYPE /dbe/vbap-jobs
                !iv_follow_up  TYPE /dbe/job-follow_up
      RETURNING VALUE(rv_body) TYPE string
      RAISING
                /dbe/cx_ars_exception.

    METHODS main_defer_job_prep
      IMPORTING
                !io_log        TYPE REF TO /dbe/cl_ars_x_log
                !iv_vbeln      TYPE /dbe/vbak_db-vbeln
                !iv_vguid      TYPE /dbe/vbak_db-vguid
                !iv_jobnr      TYPE /dbe/vbap-jobs
      RETURNING VALUE(rv_body) TYPE string
      RAISING
                /dbe/cx_ars_exception.

    METHODS main_confirm_job_prep
      IMPORTING
                !io_log        TYPE REF TO /dbe/cl_ars_x_log
                !iv_vbeln      TYPE /dbe/vbak_db-vbeln
                !iv_vguid      TYPE /dbe/vbak_db-vguid
                !iv_jobnr      TYPE /dbe/vbap-jobs
      RETURNING VALUE(rv_body) TYPE string
      RAISING
                /dbe/cx_ars_exception.

    METHODS main_reject_job
      IMPORTING
                !io_log        TYPE REF TO /dbe/cl_ars_x_log
                !iv_vbeln      TYPE /dbe/vbak_db-vbeln
                !iv_vguid      TYPE /dbe/vbak_db-vguid
                !iv_jobnr      TYPE /dbe/vbap-jobs
                !iv_rej_reason TYPE tvagt-bezei
      RETURNING VALUE(rv_body) TYPE string
      RAISING
                /dbe/cx_ars_exception.

    METHODS main_reject_job_prep
      IMPORTING
                !io_log        TYPE REF TO /dbe/cl_ars_x_log
                !iv_vbeln      TYPE /dbe/vbak_db-vbeln
                !iv_vguid      TYPE /dbe/vbak_db-vguid
                !iv_jobnr      TYPE /dbe/vbap-jobs
      RETURNING VALUE(rv_body) TYPE string
      RAISING
                /dbe/cx_ars_exception.

    METHODS confirm_job
      IMPORTING
        !iv_jobnr TYPE /dbe/vbap-jobs
        !io_log   TYPE REF TO /dbe/cl_ars_x_log
      RAISING
        /dbe/cx_ars_exception
        lcx_already_confirmed
        lcx_cant_be_confirmed .

    METHODS defer_job
      IMPORTING
        !iv_jobnr     TYPE /dbe/vbap-jobs
        !iv_follow_up TYPE /dbe/job-follow_up
        !io_log       TYPE REF TO /dbe/cl_ars_x_log
      RAISING
        /dbe/cx_ars_exception
        lcx_already_confirmed
        lcx_cant_be_confirmed .

    METHODS reject_job
      IMPORTING
        !iv_jobnr      TYPE /dbe/vbap-jobs
        !iv_rej_reason TYPE /dbe/job-abgru
        !io_log        TYPE REF TO /dbe/cl_ars_x_log
      RAISING
        /dbe/cx_ars_exception
        lcx_already_confirmed
        lcx_cant_be_confirmed .

    METHODS read_order
      IMPORTING
        !io_log   TYPE REF TO /dbe/cl_ars_x_log
        !iv_vbeln TYPE /dbe/vbak_db-vbeln
        !iv_actvt TYPE activ_auth
      RAISING
        /dbe/cx_ars_exception
        lcx_order_locked .
    METHODS call_order_engine
      IMPORTING
        !io_log                         TYPE REF TO /dbe/cl_ars_x_log
        !iv_event                       TYPE /dbe/oe_event
        !iv_dialog                      TYPE abap_bool DEFAULT abap_false
        !iv_confirmation_message_before TYPE abap_bool DEFAULT abap_false
      RAISING
        /dbe/cx_ars_exception
        lcx_cant_be_confirmed .
    METHODS save_order
      IMPORTING
        !io_log                        TYPE REF TO /dbe/cl_ars_x_log
        !iv_no_commit                  TYPE abap_bool DEFAULT abap_true
        !iv_confirmation_message_after TYPE abap_bool DEFAULT abap_true
      RAISING
        /dbe/cx_ars_exception
        lcx_cant_be_confirmed .
    METHODS build_html_response
      IMPORTING
        !iv_templ_id   TYPE smtg_tmpl_id
        !iv_jobnr      TYPE /dbe/vbap-jobs
      RETURNING
        VALUE(rv_body) TYPE string
      RAISING
        /dbe/cx_ars_exception .
    METHODS get_service_url
      IMPORTING !iv_message   TYPE /dbe/ars_camtr-message_id_inp
      RETURNING VALUE(rv_url) TYPE string.
    METHODS get_rej_reasons RETURNING VALUE(rt_rej_reasons) TYPE tt_rej_reason.

    METHODS get_rej_reason_for_descr
      IMPORTING !io_log              TYPE REF TO /dbe/cl_ars_x_log
                iv_description       TYPE tvagt-bezei
      RETURNING VALUE(rv_rej_reason) TYPE tvagt-abgru
      RAISING
                /dbe/cx_ars_exception .

    METHODS replace_token IMPORTING iv_token TYPE string
                                    iv_value TYPE clike
                          CHANGING  cv_body  TYPE string.

    CLASS-METHODS mime_get_content IMPORTING iv_foldername     TYPE skwf_url
                                             iv_mimename       TYPE skwf_url
                                   RETURNING VALUE(rv_content) TYPE string.

ENDCLASS.



CLASS ZCL_VSSJAD_A_ORD_JOB_CONF_API IMPLEMENTATION.


  METHOD /dbe/if_ars_e_http_handler~handle_request.

    DATA:
      lt_url_parameters TYPE tihttpnvp,
      ls_url_parameters LIKE LINE OF lt_url_parameters[],
      ls_input          TYPE ts_input,
      lv_body           TYPE string.

    io_http_server->request->get_form_fields( CHANGING fields = lt_url_parameters[] ).
    TRY.

        LOOP AT lt_url_parameters INTO ls_url_parameters.
          CASE to_upper( ls_url_parameters-name ).
            WHEN 'G'.                                       "#EC NOTEXT
              ls_input-vguid = ls_url_parameters-value.
            WHEN 'J'.                                       "#EC NOTEXT
              ls_input-jobnr = ls_url_parameters-value.
            WHEN 'V'.                                       "#EC NOTEXT
              ls_input-vbeln = ls_url_parameters-value.
            WHEN 'RR'.
              ls_input-rej_reason = ls_url_parameters-value.
            WHEN 'REMIND'.
              TRY.
                  CALL METHOD cl_abap_datfm=>conv_date_ext_to_int
                    EXPORTING
                      im_datext   = ls_url_parameters-value
                      im_datfmdes = '6'
                    IMPORTING
                      ex_datint   = ls_input-follow_up.
                CATCH cx_root.
                  MESSAGE e711(/dbe/common) INTO mv_dummy.  "#EC NOTEXT
                  io_log->add_symsg(  ).
                  RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
              ENDTRY.
          ENDCASE.
        ENDLOOP.
      CATCH cx_sy_conversion_error.
        MESSAGE e711(/dbe/common) INTO mv_dummy.            "#EC NOTEXT
        io_log->add_symsg(  ).
        RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
    ENDTRY.


    CASE is_call_info-s_camiv-message_id.
      WHEN c_message_job_confirm.                           "#EC NOTEXT
        lv_body = main_confirm_job( io_log = io_log iv_vbeln = ls_input-vbeln iv_jobnr = ls_input-jobnr iv_vguid = ls_input-vguid ).

      WHEN c_message_job_defer.
        lv_body = main_defer_job_prep( io_log = io_log iv_vbeln = ls_input-vbeln iv_jobnr = ls_input-jobnr iv_vguid = ls_input-vguid ).
      WHEN c_message_job_defer_conf.
        lv_body = main_defer_job( io_log       = io_log
                                  iv_vbeln     = ls_input-vbeln
                                  iv_jobnr     = ls_input-jobnr
                                  iv_vguid     = ls_input-vguid
                                  iv_follow_up = ls_input-follow_up ).
      WHEN c_message_job_reject.
        lv_body = main_reject_job_prep( io_log = io_log iv_vbeln = ls_input-vbeln iv_jobnr = ls_input-jobnr iv_vguid = ls_input-vguid ).
      WHEN c_message_job_reject_conf.
        lv_body = main_reject_job( io_log        = io_log
                                   iv_vbeln      = ls_input-vbeln
                                   iv_jobnr      = ls_input-jobnr
                                   iv_vguid      = ls_input-vguid
                                   iv_rej_reason = ls_input-rej_reason ).
      WHEN c_message_job_conf_request.
        lv_body = main_confirm_job_prep( io_log   = io_log
                                         iv_vbeln = ls_input-vbeln
                                         iv_jobnr = ls_input-jobnr
                                         iv_vguid = ls_input-vguid ).

      WHEN OTHERS.
        MESSAGE e067(/dbe/ars) INTO mv_dummy.               "#EC NOTEXT
        io_log->add_symsg(  ).
        RAISE EXCEPTION TYPE /dbe/cx_ars_exception.

    ENDCASE.

    /dbe/cl_ars_x_api=>http_srv_response_data_set(
      iv_log_handle   = io_log->get_ballog_handle( )
      io_http_server  = io_http_server
      iv_content_type = /dbe/cl_ars_x_const=>mc_http_content_type-text_html
      iv_data_str     = lv_body ).
  ENDMETHOD.


  METHOD build_html_response.
    DATA: ls_job       LIKE LINE OF mo_order->mt_job_com,
          lv_dummy(30) TYPE c.


    /dbe/cl_cf_x_tools=>read_smtg_template( EXPORTING iv_tmpl_id   = iv_templ_id
                                            IMPORTING ev_body_html = rv_body ).

    READ TABLE mo_order->mt_job_com INTO ls_job WITH KEY jobnr = iv_jobnr  .
    WRITE ls_job-j_brtwr TO lv_dummy CURRENCY ls_job-waerk.



    replace_token( EXPORTING iv_token = `{LOGO_BASE64}`
                             iv_value = get_logo_base64( )
                   CHANGING  cv_body  = rv_body ).

    replace_token( EXPORTING iv_token = `{JOB_DESCRIPTION}`
                             iv_value = ls_job-descr1 && ls_job-descr2 && ls_job-descr3 && ls_job-descr4
                   CHANGING  cv_body  = rv_body ).

    replace_token( EXPORTING iv_token = `{LIC_PLATE}`
                             iv_value = mo_order->ms_vbak_com-licpl
                   CHANGING  cv_body  = rv_body ).

    replace_token( EXPORTING iv_token = `{COST}`
                             iv_value = lv_dummy
                   CHANGING  cv_body  = rv_body ).

    replace_token( EXPORTING iv_token = `{CURRENCY}`
                             iv_value = ls_job-waerk
                   CHANGING  cv_body  = rv_body ).

    replace_token( EXPORTING iv_token = `{VBELN}`
                             iv_value = mo_order->ms_vbak_com-vbeln
                   CHANGING  cv_body  = rv_body ).

    replace_token( EXPORTING iv_token = `{VGUID}`
                             iv_value = mo_order->ms_vbak_com-vguid
                   CHANGING  cv_body  = rv_body ).

    replace_token( EXPORTING iv_token = `{JOBNR}`
                             iv_value = iv_jobnr
                   CHANGING  cv_body  = rv_body ).

    replace_token( EXPORTING iv_token = `{URL_RESTART}`
                             iv_value = get_service_url( c_message_job_conf_request )
                   CHANGING  cv_body  = rv_body ).
  ENDMETHOD.


  METHOD call_order_engine.

    TRY.
        CALL METHOD /dbe/cl_order_engine=>run
          EXPORTING
            iv_event      = iv_event
            io_ord_object = mo_order.

      CATCH /dbe/cx_oe_nothing_selected.
        io_log->add_from_bapi(  mo_order->bal_export( ) ).
        RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
      CATCH /dbe/cx_oe_user_abort.
        io_log->add_from_bapi(  mo_order->bal_export( ) ).
        RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
      CATCH /dbe/cx_oe_event_denied.
        io_log->add_from_bapi(  mo_order->bal_export( ) ).
        RAISE EXCEPTION TYPE lcx_cant_be_confirmed.
      CATCH /dbe/cx_oe_action_error.
        io_log->add_from_bapi(  mo_order->bal_export( ) ).
        RAISE EXCEPTION TYPE lcx_cant_be_confirmed.
      CATCH /dbe/cx_oe_internal_error.
        io_log->add_from_bapi(  mo_order->bal_export( ) ).
        RAISE EXCEPTION TYPE lcx_cant_be_confirmed.
    ENDTRY.

  ENDMETHOD.


  METHOD confirm_job.
    CONSTANTS:
      lc_tabname TYPE seocpdname VALUE 'MT_JOB_COM'.        "#EC NOTEXT

    ASSERT mo_order IS BOUND.
    DATA ls_job LIKE LINE OF mo_order->mt_job_com.

    READ TABLE mo_order->mt_job_com INTO ls_job WITH KEY jobnr = iv_jobnr  .

    IF sy-subrc = 0.
      IF ls_job-additional_work = abap_false.
        MESSAGE e159(/dbe/order) WITH iv_jobnr INTO mv_dummy.
        io_log->add_symsg(  ).
        RAISE EXCEPTION TYPE lcx_cant_be_confirmed.
      ENDIF.

      IF ls_job-approved = abap_true.
        MESSAGE i149(/dbe/order) INTO mv_dummy.
        io_log->add_symsg(  ).
        RAISE EXCEPTION TYPE lcx_already_confirmed.
      ENDIF.

      CLEAR: ls_job-abgru, ls_job-follow_up, ls_job-rejected, ls_job-deferred_work.
      ls_job-approv_user = sy-uname.
      ls_job-approved = abap_true.
      ls_job-slctd = abap_true.
      ls_job-slctd_ext = abap_true.
      APPEND ls_job TO mo_order->mt_job_detail.
      mo_order->job_change( ).

      call_order_engine(
        io_log   = io_log
        iv_event = /dbe/cl_order_engine=>c_ord_job_change ).

      CALL METHOD mo_order->mo_status->set_job
        EXPORTING
          iv_action = 'CUST_APPROVAL'
          iv_status = /dbe/cl_oe_status_handling=>c_complete
          iv_jobnr  = iv_jobnr.

        CALL METHOD mo_order->mo_status->set_job
          EXPORTING
            iv_action = 'JOB_REJECT'
            iv_status = /dbe/cl_oe_status_handling=>c_open
            iv_jobnr  = iv_jobnr.

      mo_order->job_status_set( ls_job ).
      mo_order->header_status_set( ).

      call_order_engine(
        io_log   = io_log
        iv_event = 'CUST_APPROVAL' ).

    ELSE.
      MESSAGE e312(/dbe/common) WITH iv_jobnr INTO mv_dummy.
      io_log->add_symsg(  ).
      RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
    ENDIF.


  ENDMETHOD.


  METHOD defer_job.
    DATA: lt_defer_reasons TYPE /dbme/mi0_tab_rej_reason,
          ls_defer_reason  LIKE LINE OF lt_defer_reasons.

    ASSERT mo_order IS BOUND.
    DATA ls_job LIKE LINE OF mo_order->mt_job_com.

    READ TABLE mo_order->mt_job_com INTO ls_job WITH KEY jobnr = iv_jobnr  .

    IF sy-subrc = 0.

      TRY.
          lt_defer_reasons = /dbme/md8_cl_x_utilities=>get_def_work_rej_reasons( mo_order ).
        CATCH /dbme/cx_cma_app_error.
          io_log->add_symsg(  ).
          RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
      ENDTRY.
      READ TABLE lt_defer_reasons INTO ls_defer_reason INDEX 1.
      IF sy-subrc <> 0.
        MESSAGE e650(/dbe/order) WITH mo_order->ms_vbak_com-vbeln iv_jobnr INTO mv_dummy.
        io_log->add_symsg(  ).
        RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
      ENDIF.
      IF ls_job-abgru = ls_defer_reason-rej_reason AND ls_job-deferred_work = abap_true.
        RAISE EXCEPTION TYPE lcx_already_confirmed.
      ELSE.
        CLEAR: ls_job-rejected, ls_job-approved.
        ls_job-abgru = ls_defer_reason-rej_reason.
        ls_job-deferred_work = abap_true.
        ls_job-follow_up = iv_follow_up.
        ls_job-slctd = abap_true.
        ls_job-slctd_ext = abap_true.
        APPEND ls_job TO mo_order->mt_job_detail.
        mo_order->job_change( ).

        CALL METHOD mo_order->mo_status->set_job
          EXPORTING
            iv_action = 'CUST_APPROVAL'
            iv_status = /dbe/cl_oe_status_handling=>c_open
            iv_jobnr  = iv_jobnr.
        CALL METHOD mo_order->mo_status->set_job
          EXPORTING
            iv_action = 'JOB_REJECT'
            iv_status = /dbe/cl_oe_status_handling=>c_complete
            iv_jobnr  = iv_jobnr.

        mo_order->job_status_set( ls_job ).
        mo_order->header_status_set( ).

        call_order_engine(
          io_log   = io_log
          iv_event = 'JOB_REJECT' ).
      ENDIF.
    ELSE.
      MESSAGE e312(/dbe/common) WITH iv_jobnr INTO mv_dummy.
      io_log->add_symsg(  ).
      RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
    ENDIF.


  ENDMETHOD.


  METHOD get_logo_base64.
    rv_logo = mime_get_content( iv_foldername = 'ZVSSJAD' iv_mimename = 'zvssjad_logo_base64' ).
  ENDMETHOD.


  METHOD get_rej_reasons.
    DATA: lt_defer_reasons TYPE /dbme/mi0_tab_rej_reason,
          ls_defer_reason  LIKE LINE OF lt_defer_reasons.
    SELECT abgru, bezei FROM tvagt
      INTO TABLE @rt_rej_reasons WHERE abgru IN ('01','02','03','04','05','10')  AND spras = @sy-langu.

    TRY.
        lt_defer_reasons = /dbme/md8_cl_x_utilities=>get_def_work_rej_reasons( mo_order ).
      CATCH /dbme/cx_cma_app_error.
    ENDTRY.
    LOOP AT lt_defer_reasons INTO ls_defer_reason.
      READ TABLE rt_rej_reasons TRANSPORTING NO FIELDS WITH KEY abgru = ls_defer_reason-rej_reason.
      IF sy-subrc = 0.
        DELETE rt_rej_reasons INDEX sy-tabix.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_rej_reason_for_descr.

    SELECT SINGLE abgru FROM tvagt INTO @rv_rej_reason WHERE bezei = @iv_description AND spras = @sy-langu. "#EC WARN_OK
    IF sy-subrc <> 0.
      MESSAGE e529(icl) INTO mv_dummy.
      io_log->add_symsg(  ).
      RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
    ENDIF.

  ENDMETHOD.


  METHOD get_service_url.
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
      lv_url_serv = lv_aliasname && '/'.
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
    "00O2TOGYBEUXY62EW059WDF18


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
    CONCATENATE 'https://' lv_host
    ""':' lv_port
     "'/'
      lv_url_serv  iv_message
      '?sap-client=' sy-mandt
                INTO rv_url.

  ENDMETHOD.


  METHOD main_confirm_job.

    FREE mo_order.

    TRY.
        read_order( io_log = io_log iv_vbeln = iv_vbeln iv_actvt = /dbe/cl_order_engine=>c_actvt_change ).
        IF mo_order->ms_header_detail-vguid <> iv_vguid.
          MESSAGE e711(/dbe/common) INTO mv_dummy.          "#EC NOTEXT
          RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
        ENDIF.
        confirm_job( io_log = io_log iv_jobnr = iv_jobnr ).
        save_order( io_log = io_log iv_no_commit = abap_false ).
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONFIRMED'  iv_jobnr = iv_jobnr ).
      CATCH lcx_already_confirmed.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_ALREADY_CONFIRMED' iv_jobnr = iv_jobnr ).
      CATCH lcx_cant_be_confirmed.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONF_FAILED' iv_jobnr = iv_jobnr ).
      CATCH lcx_order_locked.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONF_LOCKED' iv_jobnr = iv_jobnr ).
    ENDTRY.

  ENDMETHOD.


  METHOD main_confirm_job_prep.
    FREE mo_order.

    TRY.
        read_order( io_log = io_log iv_vbeln = iv_vbeln iv_actvt = /dbe/cl_order_engine=>c_actvt_display ).
        IF mo_order->ms_header_detail-vguid <> iv_vguid.
          MESSAGE e711(/dbe/common) INTO mv_dummy.          "#EC NOTEXT
          RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
        ENDIF.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONF_REQUEST'  iv_jobnr = iv_jobnr ).
        replace_token( EXPORTING iv_token = `{URL_DEFER}`
                                 iv_value = get_service_url( c_message_job_defer )
                       CHANGING  cv_body  = rv_body ).
        replace_token( EXPORTING iv_token = `{URL_CONFIRM}`
                                 iv_value = get_service_url( c_message_job_confirm )
                       CHANGING  cv_body  = rv_body ).
        replace_token( EXPORTING iv_token = `{URL_REJECT}`
                                 iv_value = get_service_url( c_message_job_reject )
                       CHANGING  cv_body  = rv_body ).
      CATCH lcx_order_locked.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONF_LOCKED' iv_jobnr = iv_jobnr ).
    ENDTRY.

  ENDMETHOD.


  METHOD main_defer_job.
    DATA lv_date_string(10) TYPE c.

    FREE mo_order.

    TRY.
        read_order( io_log = io_log iv_vbeln = iv_vbeln iv_actvt = /dbe/cl_order_engine=>c_actvt_change ).
        IF mo_order->ms_header_detail-vguid <> iv_vguid.
          MESSAGE e711(/dbe/common) INTO mv_dummy.          "#EC NOTEXT
          RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
        ENDIF.

        TRY.
            defer_job( io_log = io_log iv_jobnr = iv_jobnr  iv_follow_up = iv_follow_up ).
            save_order( io_log = io_log iv_no_commit = abap_false ).
          CATCH lcx_already_confirmed.
        ENDTRY.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_DEFER_CONF'  iv_jobnr = iv_jobnr ).
        TRY.
            CALL METHOD cl_abap_datfm=>conv_date_int_to_ext
              EXPORTING
                im_datint   = iv_follow_up
                im_datfmdes = '6'
              IMPORTING
                ex_datext   = lv_date_string.
          CATCH cx_abap_datfm_format_unknown.
            io_log->add_symsg(  ).
            RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
        ENDTRY.
        replace_token( EXPORTING iv_token = `{FOLLOW_UP}`
                                 iv_value = lv_date_string
                       CHANGING  cv_body  = rv_body ).

      CATCH lcx_cant_be_confirmed.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONF_FAILED' iv_jobnr = iv_jobnr ).
      CATCH lcx_order_locked.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONF_LOCKED' iv_jobnr = iv_jobnr ).
    ENDTRY.

  ENDMETHOD.


  METHOD main_defer_job_prep.
    DATA: lv_date            TYPE d,
          lv_date_string(10) TYPE c.

    FREE mo_order.

    TRY.
        read_order( io_log = io_log iv_vbeln = iv_vbeln iv_actvt = /dbe/cl_order_engine=>c_actvt_display ).
        IF mo_order->ms_header_detail-vguid <> iv_vguid.
          MESSAGE e711(/dbe/common) INTO mv_dummy.          "#EC NOTEXT
          RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
        ENDIF.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_DEFER'  iv_jobnr = iv_jobnr ).
        replace_token( EXPORTING iv_token = `{URL_DEFER_CONF}`
                                 iv_value = get_service_url( c_message_job_defer_conf )
                       CHANGING  cv_body  = rv_body ).
        replace_token( EXPORTING iv_token = `{URL_REJECT}`
                                 iv_value = get_service_url( c_message_job_reject )
                       CHANGING  cv_body  = rv_body ).
        lv_date = sy-datum + 30.
        TRY.
            CALL METHOD cl_abap_datfm=>conv_date_int_to_ext
              EXPORTING
                im_datint   = lv_date
                im_datfmdes = '6'
              IMPORTING
                ex_datext   = lv_date_string.


            replace_token( EXPORTING iv_token = `{DEFAULT_DATE}`
                                     iv_value = lv_date_string
                           CHANGING  cv_body  = rv_body ).
            lv_date = sy-datum + 3.

            CALL METHOD cl_abap_datfm=>conv_date_int_to_ext
              EXPORTING
                im_datint   = lv_date
                im_datfmdes = '6'
              IMPORTING
                ex_datext   = lv_date_string.
            replace_token( EXPORTING iv_token = `{MIN_DATE}`
                                     iv_value = lv_date_string
                           CHANGING  cv_body  = rv_body ).

          CATCH cx_abap_datfm_format_unknown.
            io_log->add_symsg(  ).
            RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
        ENDTRY.

      CATCH lcx_cant_be_confirmed.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONF_FAILED' iv_jobnr = iv_jobnr ).
      CATCH lcx_order_locked.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONF_LOCKED' iv_jobnr = iv_jobnr ).
    ENDTRY.

  ENDMETHOD.


  METHOD main_reject_job.
    DATA lv_rej_reason TYPE /dbe/job-abgru.

    FREE mo_order.

    TRY.
        read_order( io_log = io_log iv_vbeln = iv_vbeln iv_actvt = /dbe/cl_order_engine=>c_actvt_change ).
        IF mo_order->ms_header_detail-vguid <> iv_vguid.
          MESSAGE e711(/dbe/common) INTO mv_dummy.          "#EC NOTEXT
          RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
        ENDIF.
        lv_rej_reason = get_rej_reason_for_descr( iv_description = iv_rej_reason io_log = io_log ).
        TRY.
            reject_job( io_log = io_log iv_jobnr = iv_jobnr  iv_rej_reason = lv_rej_reason ).
            save_order( io_log = io_log iv_no_commit = abap_false ).
          CATCH lcx_already_confirmed.
        ENDTRY.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_REJECT_CONF'  iv_jobnr = iv_jobnr ).
      CATCH lcx_cant_be_confirmed.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONF_FAILED' iv_jobnr = iv_jobnr ).
      CATCH lcx_order_locked.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONF_LOCKED' iv_jobnr = iv_jobnr ).
    ENDTRY.

  ENDMETHOD.


  METHOD main_reject_job_prep.
    DATA: lv_rejection_dictionary TYPE string,
          lt_reasons              TYPE tt_rej_reason,
          ls_reason               LIKE LINE OF lt_reasons.


    FREE mo_order.

    TRY.
        read_order( io_log = io_log iv_vbeln = iv_vbeln iv_actvt = /dbe/cl_order_engine=>c_actvt_display ).
        IF mo_order->ms_header_detail-vguid <> iv_vguid.
          MESSAGE e711(/dbe/common) INTO mv_dummy.          "#EC NOTEXT
          RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
        ENDIF.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_REJECT'  iv_jobnr = iv_jobnr ).

        replace_token( EXPORTING iv_token = `{URL_REJECT_CONF}`
                                 iv_value = get_service_url( c_message_job_reject_conf )
                       CHANGING  cv_body  = rv_body ).
        lt_reasons = get_rej_reasons( ).
        LOOP AT lt_reasons INTO ls_reason.
          lv_rejection_dictionary = lv_rejection_dictionary && `<option value="` && ls_reason-desc && `">`.
        ENDLOOP.
        replace_token( EXPORTING iv_token = `{REASONS}`
                                 iv_value = lv_rejection_dictionary
                       CHANGING  cv_body  = rv_body ).

      CATCH lcx_cant_be_confirmed.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONF_FAILED' iv_jobnr = iv_jobnr ).
      CATCH lcx_order_locked.
        rv_body = build_html_response( iv_templ_id = 'ZVSSJAD_JOB_CONF_LOCKED' iv_jobnr = iv_jobnr ).
    ENDTRY.

  ENDMETHOD.


  METHOD mime_get_content.

    DATA: lt_mimes    TYPE wbmr_mime_table,
          ls_mime     LIKE LINE OF lt_mimes,
          lt_bin_data TYPE sdokcntbins,
          lv_size     TYPE i,
          lv_language TYPE syst-langu.

    CALL METHOD cl_wb_mime_repository=>get_all_mimes
      EXPORTING
        folder_name          = iv_foldername
      IMPORTING
        mimes                = lt_mimes
      EXCEPTIONS
        no_folder_name       = 1
        name_space_not_found = 2
        folder_not_found     = 3
        error_occured        = 4
        OTHERS               = 5.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    READ TABLE lt_mimes INTO ls_mime WITH KEY name = iv_mimename .
    CHECK sy-subrc = 0.

    CALL METHOD cl_wb_mime_repository=>load_mime
      EXPORTING
        io              = ls_mime-io
      IMPORTING
        filesize        = lv_size
        bin_data        = lt_bin_data
      CHANGING
        language        = lv_language
      EXCEPTIONS
        no_io           = 1
        illegal_io_type = 2
        not_found       = 3
        error_occured   = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    CALL FUNCTION 'SCMS_BINARY_TO_STRING'
      EXPORTING
        input_length = lv_size
      IMPORTING
        text_buffer  = rv_content
      TABLES
        binary_tab   = lt_bin_data
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD read_order.

************************************************************************
*
*  Project...........: proaxia VSS - FSM Integration
*  Description.......: Read DBE Order
*
*  Author............: Mariusz Kakol
*  Company...........: Proaxia
*  Creation Date.....: 2020.01.22
*
************************************************************************
*  Changed on:  Changed by:   Change ID:  Description:
*
*  2020.01.22   M.Kakol                   First ver.
************************************************************************
    DATA:
      ls_dialog_control TYPE /dbe/oe_dialog_control,
      lt_bapiret        TYPE bapiret2_t.

    FIELD-SYMBOLS:
      <ls_bapiret> LIKE LINE OF lt_bapiret[].

************************************************************************
* Read the order
************************************************************************
    ls_dialog_control-actvt = iv_actvt.

    CALL FUNCTION '/DBE/OE_MAIN_GET'
      EXPORTING
        iv_vbeln          = iv_vbeln
        is_dialog_control = ls_dialog_control
      IMPORTING
        eo_order          = me->mo_order
      TABLES
        et_return         = lt_bapiret[]
      EXCEPTIONS
        internal_error    = 1
        nothing_selected  = 2
        action_error      = 3
        OTHERS            = 4.
    IF sy-subrc = 0.
*      /pacg/ecm_cl_x_common=>add_from_bapi( it_bapiret2 = lt_bapiret[] ).
    ELSE.
      IF lt_bapiret[] IS NOT INITIAL.
        "Remove unwanted (confusing) messages
        LOOP AT lt_bapiret[] ASSIGNING <ls_bapiret>.
          IF <ls_bapiret>-id = '/DBE/COMMON' AND <ls_bapiret>-number = '896'. "#EC NOTEXT
            DELETE lt_bapiret.
            CONTINUE.
          ENDIF.
          IF <ls_bapiret>-id = '/DBE/OE' AND <ls_bapiret>-number = '009'. "#EC NOTEXT
            DELETE lt_bapiret.
            CONTINUE.
          ENDIF.
        ENDLOOP.
        UNASSIGN <ls_bapiret>.
        READ TABLE lt_bapiret TRANSPORTING NO FIELDS WITH KEY id = `/DBE/RFC_COMMON`  number = `057`.
        IF sy-subrc = 0.
          ls_dialog_control-actvt = /dbe/cl_order_engine=>c_actvt_display .
          CALL FUNCTION '/DBE/OE_MAIN_GET'
            EXPORTING
              iv_vbeln          = iv_vbeln
              is_dialog_control = ls_dialog_control
            IMPORTING
              eo_order          = me->mo_order
            TABLES
              et_return         = lt_bapiret[]
            EXCEPTIONS
              internal_error    = 1
              nothing_selected  = 2
              action_error      = 3
              OTHERS            = 4.
          IF sy-subrc <> 0.
            io_log->add_from_bapi( it_bapiret2 = lt_bapiret[] ).
            RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
          ENDIF.
          RAISE EXCEPTION TYPE lcx_order_locked.
        ENDIF.
        io_log->add_from_bapi( it_bapiret2 = lt_bapiret[] ).
        RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
      ELSE.
        IF sy-msgid IS NOT INITIAL AND sy-msgty IS NOT INITIAL AND sy-msgno IS NOT INITIAL.
          io_log->add_symsg(  ).
          RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
        ELSE.
*          MESSAGE e001(ydbf) INTO /pacg/ecm_cl_x_common=>mv_dummy WITH '/DBE/OE_MAIN_GET' sy-subrc.
*          /pacg/ecm_cl_x_common=>add_symsg_with_raise( ).
          ASSERT 1 = 2.
        ENDIF.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD reject_job.
    DATA: lt_defer_reasons TYPE /dbme/mi0_tab_rej_reason,
          ls_defer_reason  LIKE LINE OF lt_defer_reasons,
          ls_job           LIKE LINE OF mo_order->mt_job_com.

    ASSERT mo_order IS BOUND.

    READ TABLE mo_order->mt_job_com INTO ls_job WITH KEY jobnr = iv_jobnr.
    IF sy-subrc <> 0.
      MESSAGE e312(/dbe/common) WITH iv_jobnr INTO mv_dummy.
      io_log->add_symsg(  ).
      RAISE EXCEPTION TYPE /dbe/cx_ars_exception.
    ENDIF.

    DATA(lx_idx) = sy-tabix.

    IF ls_job-rejected = abap_true.
      RAISE EXCEPTION TYPE lcx_already_confirmed.
    ENDIF.

    ls_job-abgru = iv_rej_reason.
    ls_job-slctd_ext = abap_true.
    CLEAR mo_order->mt_job_detail.
    APPEND ls_job TO mo_order->mt_job_detail.

    mo_order->set_ext_slctd( iv_index   = lx_idx
                             iv_tabname = 'MT_JOB_COM' ).

    call_order_engine(
      io_log   = io_log
      iv_event = 'JOB_REJECT' ).

  ENDMETHOD.


  METHOD replace_token.
    DATA: lv_name_lower TYPE string,
          lv_name_upper TYPE string.
    lv_name_lower = to_lower( iv_token ).
    lv_name_upper = to_upper( iv_token ).
    REPLACE ALL OCCURRENCES OF lv_name_lower IN cv_body WITH iv_value.
    REPLACE ALL OCCURRENCES OF lv_name_upper IN cv_body WITH iv_value.

  ENDMETHOD.


  METHOD save_order.

    call_order_engine(
      io_log   = io_log
      iv_event = /dbe/cl_order_engine=>c_ord_save ).


  ENDMETHOD.
ENDCLASS.
