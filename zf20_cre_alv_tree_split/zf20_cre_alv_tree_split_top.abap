*&---------------------------------------------------------------------*
*&  Include           ZF20_CRE_ALV_TREE_SPLIT_TOP
*&---------------------------------------------------------------------*

TABLES: ekpo.


*&---------------------------------------------------------------------*
*&  Declaración de tipos.
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_ekko,
        ebeln TYPE ekko-ebeln,
        bukrs TYPE ekko-bukrs,
        bstyp TYPE ekko-bstyp,
        lifnr TYPE ekko-lifnr,
        ernam TYPE ekko-ernam,
      END OF ty_ekko.

TYPES: BEGIN OF ty_ekpo,
        ebeln TYPE ekpo-ebeln,
        ebelp TYPE ekpo-ebelp,
        aedat TYPE ekpo-aedat,
        txz01 TYPE ekpo-txz01,
        matnr TYPE ekpo-matnr,
        werks TYPE ekpo-werks,
        lgort TYPE ekpo-lgort,
        kunnr TYPE ekpo-kunnr,
        menge TYPE ekpo-menge,
        meins TYPE ekpo-meins,
      END OF ty_ekpo.

*&---------------------------------------------------------------------*
*&  Declaración de tablas.
*&---------------------------------------------------------------------*
DATA: gt_ekko TYPE STANDARD TABLE OF ty_ekko,
      gt_ekpo TYPE STANDARD TABLE OF ty_ekpo,
      gt_alv  TYPE STANDARD TABLE OF zf20_cre_alv_tree.

*&---------------------------------------------------------------------*
*&  Declaración de variables globales.
*&---------------------------------------------------------------------*
DATA: gv_error   TYPE flag,
      gv_display TYPE flag,
      ok_code    TYPE sy-ucomm.

*&---------------------------------------------------------------------*
*&  Declaración de objetos.
*&---------------------------------------------------------------------*

DATA: go_container   TYPE REF TO cl_gui_custom_container, " Para crear el contenedor.
      go_split       TYPE REF TO cl_gui_splitter_container, " Contenedor del split
      go_container_1 TYPE REF TO cl_gui_container, " Contenedor abstracto para el split.
      go_container_2 TYPE REF TO cl_gui_container, " Contenedor abstracto para el ALV.
      go_tree        TYPE REF TO cl_simple_tree_model, " Control del arbol con almacenamiento.
      go_alv1        TYPE REF TO cl_gui_alv_grid,
      go_alv2        TYPE REF TO cl_gui_alv_grid.