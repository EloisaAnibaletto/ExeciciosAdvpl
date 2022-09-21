#include "esa006.ch"
#include "PROTHEUS.CH"
#include "FWMVCDEF.CH"

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA006M
Monta a rotina de diciplinas em MVC

@author Eloisa Anibaletto
@since 12/09/2022
/*/
//--------------------------------------------------------------------- 
Function ESA006M()  
	
	// Armazena as variáveis
	//Local aNGBEGINPRM := NGBEGINPRM( _nVERSAO )
	
	Local oBrowse
		
		oBrowse := FWMBrowse():New()
			oBrowse:SetAlias( 'ZZ6' )			
			oBrowse:SetMenuDef( 'ESA006M' )	
			oBrowse:SetDescription( STR0001 )
		oBrowse:Activate()
		
		// Devolve as variáveis armazenadas
		//NGRETURNPRM(aNGBEGINPRM)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA006M
Definição do Menu (padrão MVC).

@author Eloisa Anibaletto
@since 12/09/2022

@return aRotina array com o Menu MVC
/*/
//--------------------------------------------------------------------- 
Static Function MenuDef()
//Inicializa MenuDef com todas as opções
	Local aRotina := {}

	aAdd( aRotina, { STR0002, 'ViewDef.ESA006M', 0, 1, 0 } ) // Pesquisar
	aAdd( aRotina, { STR0003, 'ViewDef.ESA006M', 0, 2, 0 } ) // Visualizar
    aAdd( aRotina, { STR0004, 'ViewDef.ESA006M', 0, 3, 0 } ) // Incluir
    aAdd( aRotina, { STR0005, 'ViewDef.ESA006M', 0, 4, 0 } ) // Alterar
    aAdd( aRotina, { STR0006, 'ViewDef.ESA006M', 0, 5, 0 } ) // Excluir

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
    
    // Cria a estrutura a ser usada no Modelo de Dados
	Local oStructZZ6 := FWFormStruct( 1 ,'ZZ6' )
	
	// Modelo de dados que será construído
	Local oModel := MPFormModel():New( 'ESA006M' ,  , { | oModel | fMPosVal( oModel ) } /*bPost*/ , /*bCommit*/ , /*bCancel*/ )

	oModel:AddFields( 'ZZ6MASTER' , Nil , oStructZZ6 )
        
	oModel:SetPrimaryKey( { 'ZZ6_FILIAL', 'ZZ6_DISC' } )
		
	oModel:SetDescription( STR0001 ) 
			
	oModel:GetModel( 'ZZ6MASTER' ):SetDescription( STR0001 ) 
			
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
	Local oModel := FWLoadModel( 'ESA006M' )

	// Cria a estrutura a ser usada na View
	Local oStructZZ6 := FWFormStruct( 2 , 'ZZ6' )

	// Interface de visualização construída
	Local oView := FWFormView():New()

	// Objeto do model a se associar a view.
	oView:SetModel( oModel )
		
	oView:AddField( 'VIEW_ZZ6' , oStructZZ6 , 'ZZ6MASTER' )

	//Adiciona um titulo para o formulário
	oView:EnableTitleView( 'VIEW_ZZ6' , STR0001 )
			
	oView:CreateHorizontalBox( 'TELAZZ6' , 100 )
	
	// Associa um View a um box
	oView:SetOwnerView( 'VIEW_ZZ6' , 'TELAZZ6' )

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
	
	Local aAreaZZ6		:= ZZ6->( GetArea() )

	Local nOperation	:= oModel:GetOperation() // Operação de ação sobre o Modelo

	Private aCHKSQL 	:= {} // Variável para consistência na exclusão (via SX9)

	aCHKSQL := NGRETSX9( "ZZ6" )

	If nOperation == 5 //Exclusão

		If !NGCHKDEL( "ZZ6" )
			lRet := .F.
		EndIf

		If lRet .And. !NGVALSX9( "ZZ6" , {} , .T. , .T. )
			lRet := .F.
		EndIf

	EndIf

	RestArea( aAreaZZ6 ) 

Return lRet
