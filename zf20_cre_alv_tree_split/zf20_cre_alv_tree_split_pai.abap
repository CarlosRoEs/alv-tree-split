*----------------------------------------------------------------------*
***INCLUDE ZF20_CRE_ALV_TREE_SPLIT_PAI.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command_9000 INPUT.
  CONSTANTS: lc_back   TYPE sy-ucomm VALUE 'BACK',
             lc_cancel TYPE sy-ucomm VALUE 'CANCEL',
             lc_exit   TYPE sy-ucomm VALUE 'EXIT'.

  CASE ok_code.
    WHEN lc_back.
      LEAVE TO SCREEN 0.
    WHEN lc_cancel.
      LEAVE TO SCREEN 9000.
    WHEN lc_exit.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                 " EXIT_COMMAND_9000  INPUT