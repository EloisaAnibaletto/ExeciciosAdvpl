#include "esa005.ch"
#include "PROTHEUS.CH"
#include "FWMVCDEF.CH"

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA005M
Monta a rotina de alunos da turma em MVC

@author Eloisa Anibaletto
@since 12/09/2022
/*/
//--------------------------------------------------------------------- 
Function ESA005M()  
	
	// Armazena as variáveis
	//Local aNGBEGINPRM := NGBEGINPRM( _nVERSAO )
	
	Local oBrowse
		
		oBrowse := FWMBrowse():New()
			oBrowse:SetAlias( 'ZZ4' )			
			oBrowse:SetMenuDef( 'ESA005M' )	
			oBrowse:SetDescription( STR0001 )
		oBrowse:Activate()
		
		// Devolve as variáveis armazenadas
		//NGRETURNPRM(aNGBEGINPRM)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA005M
Definição do Menu (padrão MVC).

@author Eloisa Anibaletto
@since 12/09/2022

@return aRotina array com o Menu MVC
/*/
//--------------------------------------------------------------------- 
Static Function MenuDef()
//Inicializa MenuDef com todas as opções
	Local aRotina := {}

	aAdd( aRotina, { STR0002, 'ViewDef.ESA005M', 0, 1, 0 } ) // Pesquisar
	aAdd( aRotina, { STR0003, 'ViewDef.ESA005M', 0, 2, 0 } ) // Visualizar
    aAdd( aRotina, { STR0004, 'ESA005MA       ', 0, 3, 0 } ) // Alunos

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
	Local oStructZZ4 := FWFormStruct( 1 ,'ZZ4' )
	
	// Modelo de dados que será construído
	Local oModel := MPFormModel():New( 'ESA005M' ,  , { | oModel | fMPosVal( oModel ) } /*bPost*/ , /*bCommit*/ , /*bCancel*/ )

	oModel:AddFields( 'ZZ4MASTER' , Nil , oStructZZ4 )
        
	oModel:SetPrimaryKey( { 'ZZ4_FILIAL', 'ZZ4_TURMA' } )
		
	oModel:SetDescription( STR0001 ) 
			
	oModel:GetModel( 'ZZ4MASTER' ):SetDescription( STR0001 ) 
			
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
	Local oModel := FWLoadModel( 'ESA005M' )

	// Cria a estrutura a ser usada na View
	Local oStructZZ4 := FWFormStruct( 2 , 'ZZ4' )

	// Interface de visualização construída
	Local oView := FWFormView():New()

		// Objeto do model a se associar a view.
	oView:SetModel( oModel )
		
	oView:AddField( 'VIEW_ZZ4' , oStructZZ4 , 'ZZ4MASTER' )

	//Adiciona um titulo para o formulário
	oView:EnableTitleView( 'VIEW_ZZ4' , STR0001 )
			
	oView:CreateHorizontalBox( 'TELAZZ4' , 100 )
	
	// Associa um View a um box
	oView:SetOwnerView( 'VIEW_ZZ4' , 'TELAZZ4' )

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
	
	Local aAreaZZ4		:= ZZ4->( GetArea() )

	Local nOperation	:= oModel:GetOperation() // Operação de ação sobre o Modelo

	Private aCHKSQL 	:= {} // Variável para consistência na exclusão (via SX9)

	aCHKSQL := NGRETSX9( "ZZ4" )

	If nOperation == 5 //Exclusão

		If !NGCHKDEL( "ZZ4" )
			lRet := .F.
		EndIf

		If lRet .And. !NGVALSX9( "ZZ4" , {} , .T. , .T. )
			lRet := .F.
		EndIf

	EndIf

	RestArea( aAreaZZ4 ) 

Return lRet
