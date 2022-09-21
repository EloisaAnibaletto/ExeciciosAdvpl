#include "esa005a.ch"
#include "PROTHEUS.CH"
#include "FWMVCDEF.CH"

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA005MA
Monta a rotina de alunos da turma em MVC

@author Eloisa Anibaletto
@since 12/09/2022
/*/
//--------------------------------------------------------------------- 
Function ESA005MA()  
	
	// Armazena as variáveis
	//Local aNGBEGINPRM := NGBEGINPRM( _nVERSAO )
	
	Local oBrowse
		
		oBrowse := FWMBrowse():New()
			oBrowse:SetAlias( 'ZZ5' )			
			oBrowse:SetMenuDef( 'ESA005MA' )	
			oBrowse:SetDescription( STR0001 )
		oBrowse:Activate()
		
		// Devolve as variáveis armazenadas
		//NGRETURNPRM(aNGBEGINPRM)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA005MA
Definição do Menu (padrão MVC).

@author Eloisa Anibaletto
@since 12/09/2022

@return aRotina array com o Menu MVC
/*/
//--------------------------------------------------------------------- 
Static Function MenuDef()
//Inicializa MenuDef com todas as opções
	Local aRotina := {}

	aAdd( aRotina, { STR0002, 'ViewDef.ESA005MA', 0, 1, 0 } ) // Pesquisar
	aAdd( aRotina, { STR0003, 'ViewDef.ESA005MA', 0, 2, 0 } ) // Visualizar
    aAdd( aRotina, { STR0004, 'ViewDef.ESA005MA', 0, 3, 0 } ) // Incluir
    aAdd( aRotina, { STR0005, 'ViewDef.ESA005MA', 0, 4, 0 } ) // Alterar
    aAdd( aRotina, { STR0006, 'ViewDef.ESA005MA', 0, 5, 0 } ) // Excluir

Return aRotina

//---------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do Modelo (padrão MVC).

@author Eloisa Anibaletto
@since 12/09/2022

@return oModel objeto do Modelo MVC
/*/
//---------------------------------------------------------------------
Static Function ModelDef()

	Local bPosZZ2 := { | cCampo | Posicione( 'ZZ2', 1, xFilial( 'ZZ2', cFilAnt ) + M->ZZ5_MATAL, cCampo ) }

	Local bPosZZ4 := { | cCampo | Posicione( 'ZZ4', 1, xFilial( 'ZZ4', cFilAnt ) + M->ZZ5_TURMA, cCampo ) }

    // Cria a estrutura a ser usada no Modelo de Dados
	Local oStructZZ5 := FWFormStruct( 1 ,'ZZ5' )
	
	// Modelo de dados que será construído
	Local oModel := MPFormModel():New( 'ESA005MA' ,  , { | oModel | fMPosVal( oModel ) } /*bPost*/ , /*bCommit*/ , /*bCancel*/ )

	oStructZZ5:AddTrigger( 'ZZ5_MATAL', 'ZZ5_NOMEAL', { || .T. }, { || Eval( bPosZZ2, 'ZZ2_NOME' ) } )
	oStructZZ5:AddTrigger( 'ZZ5_TURMA', 'ZZ5_DESCT' , { || .T. }, { || Eval( bPosZZ4, 'ZZ4_DESCT' ) } )

	oModel:AddFields( 'ZZ5MASTER' , Nil , oStructZZ5 )
        
	oModel:SetPrimaryKey( { 'ZZ5_FILIAL', 'ZZ5_TURMA' } )
		
	oModel:SetDescription( STR0001 ) 
			
	oModel:GetModel( 'ZZ5MASTER' ):SetDescription( STR0001 ) 
			
Return oModel

//---------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição da View (padrão MVC).

@author Eloisa Anibaletto
@since 12/09/2022

@return oView objeto da View MVC
/*/
//---------------------------------------------------------------------
Static Function ViewDef()
	
	// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
	Local oModel := FWLoadModel( 'ESA005MA' )

	// Cria a estrutura a ser usada na View
	Local oStructZZ5 := FWFormStruct( 2 , 'ZZ5' )

	// Interface de visualização construída
	Local oView := FWFormView():New()

	// Objeto do model a se associar a view.
	oView:SetModel( oModel )
		
	oView:AddField( 'VIEW_ZZ5' , oStructZZ5 , 'ZZ5MASTER' )

	//Adiciona um titulo para o formulário
	oView:EnableTitleView( 'VIEW_ZZ5' , STR0001 )
			
	oView:CreateHorizontalBox( 'TELAZZ5' , 100 )
	
	// Associa um View a um box
	oView:SetOwnerView( 'VIEW_ZZ5' , 'TELAZZ5' )

Return oView

//---------------------------------------------------------------------
/*/{Protheus.doc} fMPosValid
Pós-validação do modelo de dados.

@author Eloisa Anibaletto
@since 12/09/2022

@param oModel - Objeto do modelo de dados (Obrigatório)

@return Lígico - Retorna verdadeiro caso validacoes estejam corretas
/*/
//---------------------------------------------------------------------
Static Function fMPosVal( oModel )
    
	Local lRet			:= .T.
	
	Local aAreaZZ5		:= ZZ5->( GetArea() )

	Local nOperation	:= oModel:GetOperation() // Operação de ação sobre o Modelo

	Private aCHKSQL 	:= {} // Variável para consistência na exclusão (via SX9)

	aCHKSQL := NGRETSX9( "ZZ5" )

	If nOperation == 5 //Exclusão

		If !NGCHKDEL( "ZZ5" )
			lRet := .F.
		EndIf

		If lRet .And. !NGVALSX9( "ZZ5" , {} , .T. , .T. )
			lRet := .F.
		EndIf

	EndIf

	RestArea( aAreaZZ5 ) 

Return lRet

///---------------------------------------------------------------------
/*/{Protheus.doc} NGANOME
Função que retorna no inic browser o nome do aluno

@author Eloisa Anibaletto
@since 12/09/2022
/*/
//---------------------------------------------------------------------
Static Function NGANOME()

	Local cFil := IIf( Len( AllTrim( ZZ5->ZZ5_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ2" ) ) ), xFilial( "ZZ2" ), ZZ5->ZZ5_FILIAL )

Return IIf( ZZ2->( dbSeek( xFilial( "ZZ2", cFil ) + ZZ5->ZZ5_MATAL ) ), ZZ2->ZZ2_NOME, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} NGADESCT
Função que retorna no inic browser a descrição da turma

@author Eloisa Anibaletto
@since 12/09/2022
/*/
//---------------------------------------------------------------------
Static Function NGADESCT()

	Local cFil := IIf( Len( AllTrim( ZZ5->ZZ5_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ4" ) ) ), xFilial( "ZZ4" ), ZZ5->ZZ5_FILIAL )

Return IIf( ZZ4->( dbSeek( xFilial( "ZZ4", cFil ) + ZZ5->ZZ5_TURMA ) ), ZZ4->ZZ4_DESCT, "" )
