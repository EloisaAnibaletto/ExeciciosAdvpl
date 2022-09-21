#include 'protheus.ch'
#include 'esa005A.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA005A
Monta a rotina de Alunos da Turma

@author Eloisa Anibaletto
@since 08/08/2022

/*/
//-------------------------------------------------------------------
User Function ESA005A()

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
	DbSelectArea( 'ZZ5' )
	DbSetOrder( 1 )
	SetBRWCHGall(.F.)
	mBrowse( 6, 1, 22, 75, 'ZZ5' )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Monta o menu da rotina

@author Eloisa Anibaletto
@since 08/08/2022

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
/*/{Protheus.doc} ESANOME
Função que retorna no inic browser o nome do aluno

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function ESANOME()

	Local cFil := IIf( Len( AllTrim( ZZ5->ZZ5_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ2" ) ) ), xFilial( "ZZ2" ), ZZ5->ZZ5_FILIAL )

Return IIf( ZZ2->( dbSeek( xFilial( "ZZ2", cFil ) + ZZ5->ZZ5_MATAL ) ), ZZ2->ZZ2_NOME, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ESADESCT
Função que retorna no inic browser a descrição da turma

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function ESADESCT()

	Local cFil := IIf( Len( AllTrim( ZZ5->ZZ5_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ4" ) ) ), xFilial( "ZZ4" ), ZZ5->ZZ5_FILIAL )

Return IIf( ZZ4->( dbSeek( xFilial( "ZZ4", cFil ) + ZZ5->ZZ5_TURMA ) ), ZZ4->ZZ4_DESCT, "" )
