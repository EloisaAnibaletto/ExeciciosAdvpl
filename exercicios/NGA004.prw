#include 'protheus.ch'
#include 'nga004.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} NGA004
Monta a rotina de exame do funcionário

@author Eloisa Anibaletto
@since 25/08/2022

/*/
//-------------------------------------------------------------------
User Function NGA004()

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
	DbSelectArea( 'ZA2' )
	DbSetOrder( 1 )
	mBrowse( 6, 1, 22, 75, 'ZA2' )

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
	    { STR0003, 'NGCAD01', 0, 2, Nil, .F. },; // "Vizualizar"
		{ STR0004, 'U_NGA004A', 0, 3, Nil, .F. }; // "Exames"
	}

Return aRotina
