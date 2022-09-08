#include 'protheus.ch'
#include 'esa004.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA004
Monta a rotina de turmas

@author Eloisa Anibaletto
@since 04/08/2022

/*/
//-------------------------------------------------------------------
User Function ESA004()

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
        {'ZZ4->ZZ4_TURMA','ZZ5', 1};
    }
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
        { STR0002, 'AxPesqui', 0, 1 },; // "Pesquisar"
        { STR0003, 'NGCAD01', 0, 2 },; // "Visualizar"
        { STR0004, 'NGCAD01', 0, 3 },; // "Incluir"
        { STR0005, 'NGCAD01', 0, 4 },; // "Alterar"
        { STR0006, 'NGCAD01', 0, 5, 3 }; // "Excluir"
    }

Return aRotina
