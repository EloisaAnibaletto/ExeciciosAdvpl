#include 'protheus.ch'
#include 'nga002.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} NGA002
Monta a rotina de ficha médica

@author Eloisa Anibaletto
@since 25/08/2022

/*/
//-------------------------------------------------------------------
User Function NGA002()

    Private aRotina := MenuDef()

    //---------------------------------------------------------------------
    // Variáveis utilizadas na função NgCad01 chamada no MenuDef
    // Define o cabecalho da tela de atualizacoes
    //---------------------------------------------------------------------
    Private bNgGrava
    Private cCadastro := OemToAnsi( STR0001 )
    Private aSMenu := {}
    Private aChkDel := {}

    //---------------------------------------------------------------------
    // Variável para consistência na exclusão (via Cadastro)
    // Recebe relação do Cadastro - Formato:
	// 1 - Chave
	// 2 - Chave da tabela associada
	// 3 - Ordem (Índice)
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

@return, aRotina, Contém as opções da rotina
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
Função que retorna no browser o nome do funcionário

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function ValNome()

	Local cFil := IIf( Len( AllTrim( ZA2->ZA2_FILIAL ) ) != Len( AllTrim( xFilial( "ZA1" ) ) ), xFilial( "ZA1" ), ZA2->ZA2_FILIAL )

Return IIf( ZA1->( dbSeek( xFilial( "ZA1", cFil ) + ZA2->ZA2_MAT ) ), ZA1->ZA1_NOME, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDtNas
Função que retorna no browser a data de nascimento 

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function ValDtNas()

	Local cFil := IIf( Len( AllTrim( ZA2->ZA2_FILIAL ) ) != Len( AllTrim( xFilial( "ZA1" ) ) ), xFilial( "ZA1" ), ZA2->ZA2_FILIAL )

Return IIf( ZA1->( dbSeek( xFilial( "ZA1", cFil ) + ZA2->ZA2_MAT ) ), ZA1->ZA1_DTNASC, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValSexo
Função que retorna no browser o sexo 

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function ValSexo()

	Local cFil := IIf( Len( AllTrim( ZA2->ZA2_FILIAL ) ) != Len( AllTrim( xFilial( "ZA1" ) ) ), xFilial( "ZA1" ), ZA2->ZA2_FILIAL )

Return IIf( ZA1->( dbSeek( xFilial( "ZA1", cFil ) + ZA2->ZA2_MAT ) ), ZA1->ZA1_SEXO, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValRg
Função que retorna no browser o RG 

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
User Function ValRg()

	Local cFil := IIf( Len( AllTrim( ZA2->ZA2_FILIAL ) ) != Len( AllTrim( xFilial( "ZA1" ) ) ), xFilial( "ZA1" ), ZA2->ZA2_FILIAL )

Return IIf( ZA1->( dbSeek( xFilial( "ZA1", cFil ) + ZA2->ZA2_MAT ) ), ZA1->ZA1_RG, "" )
