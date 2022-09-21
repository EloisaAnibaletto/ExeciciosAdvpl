#include 'protheus.ch'
#include 'esa007.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA007
Monta a rotina de Notas

@author Eloisa Anibaletto
@since 09/08/2022

/*/
//-------------------------------------------------------------------
User Function ESA007()

    Private aRotina := MenuDef()

    //---------------------------------------------------------------------
    // Variaveis utilizadas na fun�ao NgCad01 chamada no MenuDef
    // Define o cabecalho da tela de atualizacoes
    //---------------------------------------------------------------------
    Private bNgGrava
    Private cCadastro := OemToAnsi( STR0001 )
    Private aSMenu := {}

    //---------------------------------------------------------------------
    // Endereca a funcao de BROWSE
    //---------------------------------------------------------------------
    DbSelectArea( 'ZZ7' )
    DbSetOrder( 1 )
    mBrowse( 6, 1, 22, 75, 'ZZ7' )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Monta o menu da rotina

@author Eloisa Anibaletto
@since 09/08/2022

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
/*/{Protheus.doc} ValNota
Fun��o que retorna uma valida��o do valor de nota

@author Eloisa Anibaletto
@since 09/08/2022
/*/
//---------------------------------------------------------------------
User Function ValNota()

    Local nNota := M->ZZ7_NOTA

    If (nNota < 0) .Or. (nNota > 10.0) 
        MsgStop( "Valor da nota incorreto", "ATEN��O" )
        Return .F.
    EndIf 

Return .T.

///---------------------------------------------------------------------
/*/{Protheus.doc} ValCodTu
Fun��o que retorna no inic browser o c�digo da turma 

@author Eloisa Anibaletto
@since 09/08/2022
/*/
//---------------------------------------------------------------------
User Function ValCodTu()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ6" ) ) ), xFilial( "ZZ6" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ6->( dbSeek( xFilial( "ZZ6", cFil ) + ZZ7->ZZ7_DISC ) ), ZZ6->ZZ6_TURMA, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDesTu
Fun��o que retorna no inic browser a descri��o da turma 

@author Eloisa Anibaletto
@since 09/08/2022
/*/
//---------------------------------------------------------------------
User Function ValDesTu()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ6" ) ) ), xFilial( "ZZ6" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ6->( dbSeek( xFilial( "ZZ6", cFil ) + ZZ7->ZZ7_DISC ) ), ZZ6->ZZ6_DESCT, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValCodMa
Fun��o que retorna no inic browser o c�digo da mat�ria 

@author Eloisa Anibaletto
@since 09/08/2022
/*/
//---------------------------------------------------------------------
User Function ValCodMa()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ6" ) ) ), xFilial( "ZZ6" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ6->( dbSeek( xFilial( "ZZ6", cFil ) + ZZ7->ZZ7_DISC ) ), ZZ6->ZZ6_CODMAT, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValCodMa
Fun��o que retorna no inic browser a descri��o da mat�ria 

@author Eloisa Anibaletto
@since 09/08/2022
/*/
//---------------------------------------------------------------------
User Function ValDesMa()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ6" ) ) ), xFilial( "ZZ6" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ6->( dbSeek( xFilial( "ZZ6", cFil ) + ZZ7->ZZ7_DISC ) ), ZZ6->ZZ6_DESCM, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValMatP
Fun��o que retorna no inic browser a matr�cula do professor 

@author Eloisa Anibaletto
@since 09/08/2022
/*/
//---------------------------------------------------------------------
User Function ValMatP()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ6" ) ) ), xFilial( "ZZ6" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ6->( dbSeek( xFilial( "ZZ6", cFil ) + ZZ7->ZZ7_DISC ) ), ZZ6->ZZ6_MAT, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValNomeP
Fun��o que retorna no inic browser o nome do professor 

@author Eloisa Anibaletto
@since 09/08/2022
/*/
//---------------------------------------------------------------------
User Function ValNomeP()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ6" ) ) ), xFilial( "ZZ6" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ6->( dbSeek( xFilial( "ZZ6", cFil ) + ZZ7->ZZ7_DISC ) ), ZZ6->ZZ6_NOMEP, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValNomeA
Fun��o que retorna no inic browser o nome do aluno

@author Eloisa Anibaletto
@since 09/08/2022
/*/
//---------------------------------------------------------------------
User Function ValNomeA()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ2" ) ) ), xFilial( "ZZ2" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ2->( dbSeek( xFilial( "ZZ2", cFil ) + ZZ7->ZZ7_MATAL ) ), ZZ2->ZZ2_NOME, "" )
