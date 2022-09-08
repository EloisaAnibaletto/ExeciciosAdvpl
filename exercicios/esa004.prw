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
