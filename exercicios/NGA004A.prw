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
Função que retorna o nome do funcionário 

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function NGANOME( cTipo )

Local cNumFic := IIf(cTipo == "X7", M->ZA4_NUMFIC, ZA4->ZA4_NUMFIC)
Local cRet := ""

	If !(Inclui .And. cTipo == "INIPAD")

		cRet := Posicione( "ZA1", 1, xFilial( "ZA1" ) +;
			Posicione( "ZA2", 1, xFilial( "ZA2" ) + cNumFic, "ZA2_MAT" ),;
			"ZA1_NOME" )

	EndIf

Return cRet


///---------------------------------------------------------------------
/*/{Protheus.doc} NGAEXA
Função que retorna a descrição do exame

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
User Function NGAEXA()

	Local cFil := IIf( Len( AllTrim( ZA4->ZA4_FILIAL ) ) != Len( AllTrim( xFilial( "ZA3" ) ) ), xFilial( "ZA3" ), ZA4->ZA4_FILIAL )

Return IIf( ZA3->( dbSeek( xFilial( "ZA3", cFil ) + ZA4->ZA4_EXAME ) ), ZA3->ZA3_DESCRI, "" )
