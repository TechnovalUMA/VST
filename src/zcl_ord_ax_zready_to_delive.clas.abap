class ZCL_ORD_AX_ZREADY_TO_DELIVE definition
  public
  final
  create public .

public section.

  interfaces /DBE/IF_OE_ACTION_EXE .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ORD_AX_ZREADY_TO_DELIVE IMPLEMENTATION.


  method /DBE/IF_OE_ACTION_EXE~EXECUTION.
DATA lo_order  TYPE REF TO /DBE/cl_order.
  lo_order  ?= io_ord_object.
cv_success = /DBE/cl_order_engine=>c_action_ok.
  endmethod.
ENDCLASS.
