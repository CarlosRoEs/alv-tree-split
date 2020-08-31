*----------------------------------------------------------------------*
***INCLUDE ZF20_CRE_ALV_TREE_SPLIT_F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATOS
*&---------------------------------------------------------------------*
*       Se obtinen los datos para crear el arbol.
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_datos .

    DATA: ls_alv LIKE LINE OF gt_alv.
  
    CLEAR ls_alv.
  
    SELECT ebeln bukrs bstyp lifnr ernam
      FROM ekko
      INTO TABLE gt_ekko
      WHERE ebeln IN s_ebeln.
  
    IF gt_ekko IS NOT INITIAL.
      DATA(lt_ekko_aux) = gt_ekko.
  
      SORT lt_ekko_aux BY ebeln.
      DELETE ADJACENT DUPLICATES FROM lt_ekko_aux COMPARING ebeln.
      IF lt_ekko_aux IS NOT INITIAL.
  
        SELECT ebeln ebelp aedat txz01 matnr werks lgort kunnr menge meins
          FROM ekpo
          INTO TABLE gt_ekpo
          FOR ALL ENTRIES IN lt_ekko_aux
          WHERE ebeln EQ lt_ekko_aux-ebeln.
  
        IF gt_ekpo IS NOT INITIAL.
  
          LOOP AT gt_ekpo ASSIGNING FIELD-SYMBOL(<fs_ekpo>).
            READ TABLE gt_ekko ASSIGNING FIELD-SYMBOL(<fs_ekko>) WITH KEY ebeln = <fs_ekpo>-ebeln.
            ls_alv-ebeln = <fs_ekko>-ebeln.
            ls_alv-ebelp = <fs_ekpo>-ebelp.
            ls_alv-bukrs = <fs_ekko>-bukrs.
            ls_alv-bstyp = <fs_ekko>-bstyp.
            ls_alv-aedat = <fs_ekpo>-aedat.
            ls_alv-lifnr = <fs_ekko>-lifnr.
            ls_alv-ernam = <fs_ekko>-ernam.
            ls_alv-txz01 = <fs_ekpo>-txz01.
            ls_alv-matnr = <fs_ekpo>-matnr.
            ls_alv-werks = <fs_ekpo>-werks.
            ls_alv-lgort = <fs_ekpo>-lgort.
            ls_alv-kunnr = <fs_ekpo>-kunnr.
            ls_alv-menge = <fs_ekpo>-menge.
            ls_alv-meins = <fs_ekpo>-meins.
  
            APPEND ls_alv TO gt_alv.
            CLEAR ls_alv.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ELSE.
      gv_error = abap_true.
    ENDIF.
  ENDFORM.                    " OBTENER_DATOS_ARBOL