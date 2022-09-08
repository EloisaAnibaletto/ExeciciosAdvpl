#include 'protheus.ch'
#include 'nga004A.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} NGA004A
Monta a rotina de exames do funcionário

@author Eloisa Anibaletto
@since 25/08/2022

/*/
//-------------------------------------------------------------------
User Function NGA004A()

	Private aRotina := MenuDef()

	//---------------------------------------------------------------------
	// Define o cabecalho da tela de atualizacoes
	//---------------------------------------------------------------------
	Private bNgGrava
	Private cCadastro := OemToAnsi( STR0001 )
	Private aSMenu := {}

	//---------------------------------------------------------------------
	// Endereca a funcao de BROWSE
	//---------------------------------------------------------------------
	DbSelectArea( 'ZA4' )
	DbSetOrder( 1 )
	SetBRWCHGall(.F.)
	mBrowse( 6, 1, 22, 75, 'ZA4' )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Monta o menu da rotina

@author Eloisa Anibaletto
@since 25/08/2022

@return, aRotina, Contém as opções da rotina
/*/
//-------------------------------------------------------------------
Static Function MenuDef()

    Local aRotina := {;
        { STR0002, 'AxPesqui', 0, 1, Nil, .F. },; // "Pesquisar"
        { STR0003, 'NGCAD01', 0, 2, Nil, .F. },; // "Visualizar"
        { STR0004, 'NGCAD01', 0, 3, Nil, .F. },; // "Incluir"
        { STR0005, 'NGCAD01', 0, 4, Nil, .F. },; // "Alterar"
        { STR0006, 'NGCAD01', 0, 5, 3, Nil, .F. }; // "Excluir"
    }

Return aRotina

///---------------------------------------------------------------------
/*/{Protheus.doc} NGANOME
Função que retorna uma validação para o campo nome do funcionário 

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function NGANOME()

	Local cFil := IIf( Len( AllTrim( ZA4->ZA4_FILIAL ) ) != Len( AllTrim( xFilial( "ZA2" ) ) ), xFilial( "ZA2" ), ZA4->ZA4_FILIAL )

Return IIf( ZA2->( dbSeek( xFilial( "ZA2", cFil ) + ZA4->ZA4_NUMFIC ) ), ZA2->ZA2_NOME, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} NGAEXA
Função que retorna uma validação para o campo descrição de exame

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function NGAEXA()

	Local cFil := IIf( Len( AllTrim( ZA4->ZA4_FILIAL ) ) != Len( AllTrim( xFilial( "ZA3" ) ) ), xFilial( "ZA3" ), ZA4->ZA4_FILIAL )

Return IIf( ZA3->( dbSeek( xFilial( "ZA3", cFil ) + ZA4->ZA4_EXAME ) ), ZA3->ZA3_DESCRI, "" )
