*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZMMA_BGMC03.....................................*
DATA:  BEGIN OF STATUS_ZMMA_BGMC03                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMMA_BGMC03                   .
CONTROLS: TCTRL_ZMMA_BGMC03
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZMMA_BGMC03                   .
TABLES: ZMMA_BGMC03                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
