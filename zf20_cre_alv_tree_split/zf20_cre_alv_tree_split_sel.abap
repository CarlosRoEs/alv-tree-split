*&---------------------------------------------------------------------*
*&  Include           ZF20_CRE_ALV_TREE_SPLIT_SEL
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&                   Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECT-OPTIONS: s_ebeln FOR ekpo-ebeln. "Número de documento de compras.

SELECTION-SCREEN: END OF BLOCK b1.