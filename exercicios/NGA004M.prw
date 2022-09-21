#include "NGA004.ch"
#include "PROTHEUS.CH"
#include "FWMVCDEF.CH"

//---------------------------------------------------------------------
/*/{Protheus.doc} NGA004M
Monta a rotina de alunos da turma em MVC

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//--------------------------------------------------------------------- 
Function NGA004M()  
	
	// Armazena as variáveis
	//Local aNGBEGINPRM := NGBEGINPRM( _nVERSAO )
	
	Local oBrowse
		
		oBrowse := FWMBrowse():New()
			oBrowse:SetAlias( 'ZA2' )			
			oBrowse:SetMenuDef( 'NGA004M' )	
			oBrowse:SetDescription( STR0001 )
		oBrowse:Activate()
		
		// Devolve as variáveis armazenadas
		//NGRETURNPRM(aNGBEGINPRM)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} NGA004M
Definição do Menu (padrão MVC).

@author Eloisa Anibaletto
@since 13/09/2022

@return aRotina array com o Menu MVC
/*/
//--------------------------------------------------------------------- 
Static Function MenuDef()
//Inicializa MenuDef com todas as opções
	Local aRotina := {}

	aAdd( aRotina, { STR0002, 'ViewDef.NGA004M', 0, 1, 0 } ) // Pesquisar
	aAdd( aRotina, { STR0003, 'ViewDef.NGA004M', 0, 2, 0 } ) // Visualizar
    aAdd( aRotina, { STR0004, 'NGA004MA       ', 0, 3, 0 } ) // Exames

Return aRotina

//---------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do Modelo (padrão MVC).

@author Eloisa Anibaletto
@since 13/09/2022

@return oModel objeto do Modelo MVC
/*/
//---------------------------------------------------------------------
Static Function ModelDef()
    
    // Cria a estrutura a ser usada no Modelo de Dados
	Local oStructZA2 := FWFormStruct( 1 ,'ZA2' )
	
	// Modelo de dados que será construído
	Local oModel := MPFormModel():New( 'NGA004M' ,  , { | oModel | fMPosVal( oModel ) } /*bPost*/ , /*bCommit*/ , /*bCancel*/ )

	oModel:AddFields( 'ZA2MASTER' , Nil , oStructZA2 )
        
	oModel:SetPrimaryKey( { 'ZA2_FILIAL', 'ZA2_NUMFIC' } )
		
	oModel:SetDescription( STR0001 ) 
			
	oModel:GetModel( 'ZA2MASTER' ):SetDescription( STR0001 ) 
			
Return oModel

//---------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição da View (padrão MVC).

@author Eloisa Anibaletto
@since 13/09/2022

@return oView objeto da View MVC
/*/
//---------------------------------------------------------------------
Static Function ViewDef()
	
	// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
	Local oModel := FWLoadModel( 'NGA004M' )

	// Cria a estrutura a ser usada na View
	Local oStructZA2 := FWFormStruct( 2 , 'ZA2' )

	// Interface de visualização construída
	Local oView := FWFormView():New()

		// Objeto do model a se associar a view.
	oView:SetModel( oModel )
		
	oView:AddField( 'VIEW_ZA2' , oStructZA2 , 'ZA2MASTER' )

	//Adiciona um titulo para o formulário
	oView:EnableTitleView( 'VIEW_ZA2' , STR0001 )
			
	oView:CreateHorizontalBox( 'TELAZA2' , 100 )
	
	// Associa um View a um box
	oView:SetOwnerView( 'VIEW_ZA2' , 'TELAZA2' )

Return oView

//---------------------------------------------------------------------
/*/{Protheus.doc} fMPosValid
Pós-validação do modelo de dados.

@author Eloisa Anibaletto
@since 13/09/2022

@param oModel - Objeto do modelo de dados (Obrigatório)

@return Lígico - Retorna verdadeiro caso validacoes estejam corretas
/*/
//---------------------------------------------------------------------
Static Function fMPosVal( oModel )
    
	Local lRet			:= .T.
	
	Local aAreaZA2		:= ZA2->( GetArea() )

	Local nOperation	:= oModel:GetOperation() // Operação de ação sobre o Modelo

	Private aCHKSQL 	:= {} // Variável para consistência na exclusão (via SX9)

	aCHKSQL := NGRETSX9( "ZA2" )

	If nOperation == 5 //Exclusão

		If !NGCHKDEL( "ZA2" )
			lRet := .F.
		EndIf

		If lRet .And. !NGVALSX9( "ZA2" , {} , .T. , .T. )
			lRet := .F.
		EndIf

	EndIf

	RestArea( aAreaZA2 ) 

Return lRet
