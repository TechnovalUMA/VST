*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSS_VEH_PROF...................................*
DATA:  BEGIN OF STATUS_ZVSS_VEH_PROF                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVSS_VEH_PROF                 .
CONTROLS: TCTRL_ZVSS_VEH_PROF
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZVSS_VEH_PROF                 .
TABLES: ZVSS_VEH_PROF                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
