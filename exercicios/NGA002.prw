#include 'protheus.ch'
#include 'nga002.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} NGA002
Monta a rotina de ficha m�dica

@author Eloisa Anibaletto
@since 25/08/2022

/*/
//-------------------------------------------------------------------
User Function NGA002()

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
        {'ZA2->ZA2_NUMFIC','ZA4', 2};
    }

    //---------------------------------------------------------------------
    // Endereca a funcao de BROWSE
    //---------------------------------------------------------------------
    DbSelectArea( 'ZA2' )
    DbSetOrder( 1 )
    mBrowse( 6, 1, 22, 75, 'ZA2' )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Monta o menu da rotina

@author Eloisa Anibaletto
@since 25/08/2022

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
/*/{Protheus.doc} ValNome
Fun��o que retorna no browser o nome do funcion�rio

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function ValNome()

	Local cFil := IIf( Len( AllTrim( ZA2->ZA2_FILIAL ) ) != Len( AllTrim( xFilial( "ZA1" ) ) ), xFilial( "ZA1" ), ZA2->ZA2_FILIAL )

Return IIf( ZA1->( dbSeek( xFilial( "ZA1", cFil ) + ZA2->ZA2_MAT ) ), ZA1->ZA1_NOME, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDtNas
Fun��o que retorna no browser a data de nascimento 

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function ValDtNas()

	Local cFil := IIf( Len( AllTrim( ZA2->ZA2_FILIAL ) ) != Len( AllTrim( xFilial( "ZA1" ) ) ), xFilial( "ZA1" ), ZA2->ZA2_FILIAL )

Return IIf( ZA1->( dbSeek( xFilial( "ZA1", cFil ) + ZA2->ZA2_MAT ) ), ZA1->ZA1_DTNASC, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValSexo
Fun��o que retorna no browser o sexo 

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function ValSexo()

	Local cFil := IIf( Len( AllTrim( ZA2->ZA2_FILIAL ) ) != Len( AllTrim( xFilial( "ZA1" ) ) ), xFilial( "ZA1" ), ZA2->ZA2_FILIAL )

Return IIf( ZA1->( dbSeek( xFilial( "ZA1", cFil ) + ZA2->ZA2_MAT ) ), ZA1->ZA1_SEXO, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValRg
Fun��o que retorna no browser o RG 

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function ValRg()

	Local cFil := IIf( Len( AllTrim( ZA2->ZA2_FILIAL ) ) != Len( AllTrim( xFilial( "ZA1" ) ) ), xFilial( "ZA1" ), ZA2->ZA2_FILIAL )

Return IIf( ZA1->( dbSeek( xFilial( "ZA1", cFil ) + ZA2->ZA2_MAT ) ), ZA1->ZA1_RG, "" )
