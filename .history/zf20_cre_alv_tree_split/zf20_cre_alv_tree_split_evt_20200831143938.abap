*&---------------------------------------------------------------------*
*&  Include           ZF20_CRE_ALV_TREE_SPLIT_EVT
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  PERFORM get_datos.

  IF gv_error IS INITIAL.
* Se llama a la dynpro.
    CALL SCREEN 9000.
  ELSE.

  ENDIF.