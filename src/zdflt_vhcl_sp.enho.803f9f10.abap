"Name: \PR:SAPLXQQM\IC:ZXQQMU25\SE:END\EI
ENHANCEMENT 0 ZDFLT_VHCL_SP.
  "Basant Hamed 19.11.2023
   "Default customer in Notification from Equipment
  FIELD-SYMBOLS: <fs_parnr> LIKE LINE OF t_partner.


IF i_viqmel-/DBE/vhguid IS NOT INITIAL.


** sold-to-party
    READ TABLE t_partner ASSIGNING <fs_parnr> WITH KEY parvw = 'AG'.
    IF sy-subrc NE 0.

        SELECT SINGLE kunnr  FROM vlcvehicle INTO t_partner-parnr
     WHERE vguid = i_viqmel-/DBE/vhguid .

          IF t_partner-parnr IS NOT INITIAL.
            t_partner-parvw = 'AG'.
            append t_partner.

          ENDIF.


    ENDIF.

 ENDIF.
ENDENHANCEMENT.
