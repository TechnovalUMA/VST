*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSS_TSKLST_PACK................................*
DATA:  BEGIN OF STATUS_ZVSS_TSKLST_PACK              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVSS_TSKLST_PACK              .
CONTROLS: TCTRL_ZVSS_TSKLST_PACK
            TYPE TABLEVIEW USING SCREEN '2000'.
*.........table declarations:.................................*
TABLES: *ZVSS_TSKLST_PACK              .
TABLES: ZVSS_TSKLST_PACK               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
