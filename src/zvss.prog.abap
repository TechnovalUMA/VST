*&---------------------------------------------------------------------*
*& Report ZVSS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvss.

PARAMETERS: pa_name   TYPE string,
            pa_lname TYPE string.

WRITE pa_name COLOR COL_POSITIVE.
NEW-LINE.
WRITE 'Hello World'.

WRITE sy-datum.
WRITE sy-uzeit.
WRITE sy-uname.

data gv_full_name type string.

CONSTANTS gc_comma type c LENGTH 1 value ','.

CONCATENATE pa_name pa_lname into gv_full_name SEPARATED BY gc_comma.

NEW-LINE.

WRITE gv_full_name.

FIND 'NADER' IN pa_name IGNORING CASE.
if sy-subrc = 0.
  write 'Name contain Nader'.
 else.
   WRITE 'Name does not contain Nader'.
   ENDIF.
