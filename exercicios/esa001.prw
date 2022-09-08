#include 'protheus.ch'
#include 'esa001.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA001
Monta a rotina de professores

@author Eloisa Anibaletto
@since 03/08/2022

/*/
//-------------------------------------------------------------------
User Function ESA001()

    Private aRotina := MenuDef()

    //---------------------------------------------------------------------
    // Vari�veis utilizadas na fun��o NgCad01 chamada no MenuDef
    // Define o cabecalho da tela de atualizacoes
    //---------------------------------------------------------------------
    Private bNgGrava
    Private cCadastro := OemToAnsi( STR0001 )
    Private aSMenu := {}
    Private aChkDel := {}

    //---------------------------------------------------------------------
    // Vari�vel para consist�ncia na exclus�o (via Cadastro)
    // Recebe rela��o do Cadastro - Formato:
	// 1 - Chave
	// 2 - Chave da tabela associada
	// 3 - Ordem (�ndice)
    //---------------------------------------------------------------------
    aChkDel := {;
        {'ZZ1->ZZ1_MAT','ZZ6', 3};
    }

    //---------------------------------------------------------------------
    // Endereca a funcao de BROWSE
    //---------------------------------------------------------------------
    DbSelectArea( 'ZZ1' )
    DbSetOrder( 1 )
    mBrowse( 6, 1, 22, 75, 'ZZ1' )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Monta o menu da rotina

@author Eloisa Anibaletto
@since 03/08/2022

@return, aRotina, Cont�m as op��es da rotina
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
/*/{Protheus.doc} ValDtAdm
Fun��o que valida que a data de admiss�o n�o pode ser menor que a data 
de nascimento

@author Eloisa Anibaletto
@since 03/08/2022
/*/
//---------------------------------------------------------------------
User Function ValDtAdm()

    Local dAdmi := M->ZZ1_DTADMI
    Local dNasc := M->ZZ1_DTNASC

    If dAdmi < dNasc 
        MsgStop( "Data de admiss�o n�o pode ser menor que data de nascimento!", "ATEN��O" )
        Return .F.
    EndIf 

Return .T.

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDtDem
Fun��o que valida que a data de demiss�o n�o pode ser menor que a data 
de admiss�o

@author Eloisa Anibaletto
@since 03/08/2022
/*/
//---------------------------------------------------------------------
User Function ValDtDem()

    Local dDemi := M->ZZ1_DTDEMI
    Local dAdmi := M->ZZ1_DTADMI

    If dDemi < dAdmi
        MsgStop( "Data de demiss�o n�o pode ser menor que data de admiss�o!", "ATEN��O" )
        Return .F.
    EndIf 

Return .T.
