"Name: \PR:SAPLXWOC\IC:ZXWOCU21\SE:END\EI
ENHANCEMENT 0 ZDFLT_VHCL.
**Basant Hamed 19.11.2023
"Default VIN in Notification from Equipment
"Read VGUID from Vehicle
IF  e_viqmel-/DBE/vhguid IS INITIAL.
  SELECT SINGLE vguid  FROM vlcvehicle INTO e_viqmel-/DBE/vhguid
     WHERE
    /dbe/equnr = e_viqmel-equnr.


ENDIF.
ENDENHANCEMENT.
