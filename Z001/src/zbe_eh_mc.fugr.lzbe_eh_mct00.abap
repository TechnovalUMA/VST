*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBE_EH_MC.......................................*
DATA:  BEGIN OF STATUS_ZBE_EH_MC                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBE_EH_MC                     .
CONTROLS: TCTRL_ZBE_EH_MC
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBE_EH_MC                     .
TABLES: ZBE_EH_MC                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
