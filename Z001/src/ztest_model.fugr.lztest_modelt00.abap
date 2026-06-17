*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTEST_MODEL.....................................*
DATA:  BEGIN OF STATUS_ZTEST_MODEL                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTEST_MODEL                   .
CONTROLS: TCTRL_ZTEST_MODEL
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTEST_MODEL                   .
TABLES: ZTEST_MODEL                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
