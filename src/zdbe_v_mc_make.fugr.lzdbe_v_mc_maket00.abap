*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDBE_V_MC_MAKE..................................*
DATA:  BEGIN OF STATUS_ZDBE_V_MC_MAKE                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDBE_V_MC_MAKE                .
CONTROLS: TCTRL_ZDBE_V_MC_MAKE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDBE_V_MC_MAKE                .
TABLES: ZDBE_V_MC_MAKE                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
