#include 'protheus.ch'
#include 'nga001.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} NGA001
Monta a rotina de funcion?rios

@author Eloisa Anibaletto
@since 25/08/2022

/*/
//-------------------------------------------------------------------
User Function NGA001()

    Private aRotina := MenuDef()

    //---------------------------------------------------------------------
    // Vari?veis utilizadas na fun??o NgCad01 chamada no MenuDef
    // Define o cabecalho da tela de atualizacoes
    //---------------------------------------------------------------------
    Private bNgGrava
    Private cCadastro := OemToAnsi( STR0001 )
    Private aSMenu := {}
    Private aChkDel := {}

    //---------------------------------------------------------------------
    // Vari?vel para consist?ncia na exclus?o (via Cadastro)
    // Recebe rela??o do Cadastro - Formato:
	// 1 - Chave
	// 2 - Chave da tabela associada
	// 3 - Ordem (?ndice)
    //---------------------------------------------------------------------
    aChkDel := {;
        {'ZA1->ZA1_MAT','ZA2', 3};
    }

    //---------------------------------------------------------------------
    // Endereca a funcao de BROWSE
    //---------------------------------------------------------------------
    DbSelectArea( 'ZA1' )
    DbSetOrder( 1 )
    mBrowse( 6, 1, 22, 75, 'ZA1' )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Monta o menu da rotina

@author Eloisa Anibaletto
@since 25/08/2022

@return, aRotina, Cont?m as op??es da rotina
/*/
//-------------------------------------------------------------------
Static Function MenuDef()

    Local aRotina := {;
        { STR0002, 'AxPesqui', 0, 1 },; // "Pesquisar"
        { STR0003, 'NGCAD01', 0, 2 },; // "Visualizar"
        { STR0004, 'NGCAD01', 0, 3 },; // "Incluir"
        { STR0005, 'NGCAD01', 0, 4 },; // "Alterar"
        { STR0006, 'NGCAD01', 0, 5, 3 }; // "Excluir"
    }

Return aRotina

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDatN
Fun??o que valida que a data de admiss?o n?o pode ser menor que a data 
de nascimento

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function ValDatN()

    Local dAdmi := M->ZA1_DTADMI
    Local dNasc := M->ZA1_DTNASC

    If dAdmi < dNasc 
        MsgStop( "Data de admiss?o n?o pode ser menor que data de nascimento!", "ATEN??O" )
        Return .F.
    EndIf 

Return .T.

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDatD
Fun??o que valida que a data de demiss?o n?o pode ser menor que a data 
de admiss?o

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function ValDatD()

    Local dDemi := M->ZA1_DTDEMI
    Local dAdmi := M->ZA1_DTADMI

    If dDemi < dAdmi
        MsgStop( "Data de demiss?o n?o pode ser menor que data de admiss?o!", "ATEN??O" )
        Return .F.
    EndIf 

Return .T.
