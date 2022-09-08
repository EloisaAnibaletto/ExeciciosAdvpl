#include 'protheus.ch'
#include 'esa003.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA003
Monta a rotina de materias

@author Eloisa Anibaletto
@since 04/08/2022

/*/
//-------------------------------------------------------------------
User Function ESA003()

    Private aRotina := MenuDef()

    //---------------------------------------------------------------------
    // Variaveis utilizadas na funçao NgCad01 chamada no MenuDef
    // Define o cabecalho da tela de atualizacoes
    //---------------------------------------------------------------------
    Private bNgGrava
    Private cCadastro := OemToAnsi( STR0001 )
    Private aSMenu := {}
    Private aChkDel := {}

    //---------------------------------------------------------------------
    // Variavel para consistencia na exclusao (via Cadastro)
    // Recebe relaçao do Cadastro - Formato:
	// 1 - Chave
	// 2 - Chave da tabela associada
	// 3 - Ordem (indice)
    //---------------------------------------------------------------------
    aChkDel := {;
        {'ZZ3->ZZ3_MATAL','ZZ6', 4};
    }

    //---------------------------------------------------------------------
    // Endereca a funcao de BROWSE
    //---------------------------------------------------------------------
    DbSelectArea( 'ZZ3' )
    DbSetOrder( 1 )
    mBrowse( 6, 1, 22, 75, 'ZZ3' )

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
        { STR0002, 'AxPesqui', 0, 1 },; // "Pesquisar"
        { STR0003, 'NGCAD01', 0, 2 },; // "Visualizar"
        { STR0004, 'NGCAD01', 0, 3 },; // "Incluir"
        { STR0005, 'NGCAD01', 0, 4 },; // "Alterar"
        { STR0006, 'NGCAD01', 0, 5, 3 }; // "Excluir"
    }

Return aRotina
