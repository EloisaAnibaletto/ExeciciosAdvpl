#include 'protheus.ch'
#include 'esa001.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA001
Monta a rotina de professores

@author Eloisa Anibaletto
@since 03/08/2022

/*/
//-------------------------------------------------------------------
User Function ESA001()

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
        {'ZZ1->ZZ1_MAT','ZZ6', 3};
    }

    //---------------------------------------------------------------------
    // Endereca a funcao de BROWSE
    //---------------------------------------------------------------------
    DbSelectArea( 'ZZ1' )
    DbSetOrder( 1 )
    mBrowse( 6, 1, 22, 75, 'ZZ1' )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Monta o menu da rotina

@author Eloisa Anibaletto
@since 03/08/2022

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
/*/{Protheus.doc} ValDtAdm
Função que valida que a data de admissão não pode ser menor que a data 
de nascimento

@author Eloisa Anibaletto
@since 03/08/2022
/*/
//---------------------------------------------------------------------
User Function ValDtAdm()

    Local dAdmi := M->ZZ1_DTADMI
    Local dNasc := M->ZZ1_DTNASC

    If dAdmi < dNasc 
        MsgStop( "Data de admissão não pode ser menor que data de nascimento!", "ATENÇÃO" )
        Return .F.
    EndIf 

Return .T.

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDtDem
Função que valida que a data de demissão não pode ser menor que a data 
de admissão

@author Eloisa Anibaletto
@since 03/08/2022
/*/
//---------------------------------------------------------------------
User Function ValDtDem()

    Local dDemi := M->ZZ1_DTDEMI
    Local dAdmi := M->ZZ1_DTADMI

    If dDemi < dAdmi
        MsgStop( "Data de demissão não pode ser menor que data de admissão!", "ATENÇÃO" )
        Return .F.
    EndIf 

Return .T.
