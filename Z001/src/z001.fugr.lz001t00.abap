*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDBE_LBR_DEF....................................*
DATA:  BEGIN OF STATUS_ZDBE_LBR_DEF                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDBE_LBR_DEF                  .
CONTROLS: TCTRL_ZDBE_LBR_DEF
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDBE_LBR_DEF                  .
TABLES: ZDBE_LBR_DEF                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
