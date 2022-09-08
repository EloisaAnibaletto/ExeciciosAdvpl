#include 'protheus.ch'
#include 'esa005.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA005
Monta a rotina de Alunos da Turma

@author Eloisa Anibaletto
@since 05/08/2022

/*/
//-------------------------------------------------------------------
User Function ESA005()

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
	DbSelectArea( 'ZZ4' )
	DbSetOrder( 1 )
	mBrowse( 6, 1, 22, 75, 'ZZ4' )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Monta o menu da rotina

@author Eloisa Anibaletto
@since 04/08/2022

@return, aRotina, Contém as opções da rotina
/*/
//-------------------------------------------------------------------
Static Function MenuDef()

	Local aRotina := {;
		{ STR0002, 'AxPesqui', 0, 1, Nil, .F. },; // "Pesquisar"
	    { STR0003, 'NGCAD01', 0, 2, Nil, .F. },; // "Vizualizar"
		{ STR0004, 'U_ESA005A', 0, 3, Nil, .F. }; // "Alunos"
	}

Return aRotina
