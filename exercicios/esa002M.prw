#include "esa002.ch"
#include "PROTHEUS.CH"
#include "FWMVCDEF.CH"

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA002M
Monta a rotina de alunos em MVC

@author Eloisa Anibaletto
@since 08/09/2022
/*/
//--------------------------------------------------------------------- 
Function ESA002M()  
	
	// Armazena as vari�veis
	//Local aNGBEGINPRM := NGBEGINPRM( _nVERSAO )
	
	Local oBrowse
		
		oBrowse := FWMBrowse():New()
			oBrowse:SetAlias( 'ZZ2' )			
			oBrowse:SetMenuDef( 'ESA002M' )	
			oBrowse:SetDescription( STR0001 )
		oBrowse:Activate()
		
		// Devolve as vari�veis armazenadas
		//NGRETURNPRM(aNGBEGINPRM)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA002M
Defini��o do Menu (padr�o MVC).

@author Eloisa Anibaletto
@since 08/09/2022

@return aRotina array com o Menu MVC
/*/
//--------------------------------------------------------------------- 
Static Function MenuDef()
//Inicializa MenuDef com todas as op��es
	Local aRotina := {}

	aAdd( aRotina, { STR0002, 'ViewDef.ESA002M', 0, 1, 0 } ) // Pesquisar
	aAdd( aRotina, { STR0003, 'ViewDef.ESA002M', 0, 2, 0 } ) // Visualizar
    aAdd( aRotina, { STR0004, 'ViewDef.ESA002M', 0, 3, 0 } ) // Incluir
    aAdd( aRotina, { STR0005, 'ViewDef.ESA002M', 0, 4, 0 } ) // Alterar
    aAdd( aRotina, { STR0006, 'ViewDef.ESA002M', 0, 5, 0 } ) // Excluir

Return aRotina

//---------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Defini��o do Modelo (padr�o MVC).

@author Eloisa Anibaletto
@since 08/09/2022

@return oModel objeto do Modelo MVC
/*/
//---------------------------------------------------------------------
Static Function ModelDef()
    
    // Cria a estrutura a ser usada no Modelo de Dados
	Local oStructZZ2 := FWFormStruct( 1 ,'ZZ2' )
	
	// Modelo de dados que ser� constru�do
	Local oModel := MPFormModel():New( 'ESA002M' ,  , { | oModel | fMPosVal( oModel ) } /*bPost*/ , /*bCommit*/ , /*bCancel*/ )

	oModel:AddFields( 'ZZ2MASTER' , Nil , oStructZZ2 )
        
	oModel:SetPrimaryKey( { 'ZZ2_FILIAL', 'ZZ2_MATAL' } )
		
	oModel:SetDescription( STR0001 ) 
			
	oModel:GetModel( 'ZZ2MASTER' ):SetDescription( STR0001 ) 
			
Return oModel

//---------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Defini��o da View (padr�o MVC).

@author Eloisa Anibaletto
@since 08/09/2022

@return oView objeto da View MVC
/*/
//---------------------------------------------------------------------
Static Function ViewDef()
	
	// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
	Local oModel := FWLoadModel( 'ESA002M' )

	// Cria a estrutura a ser usada na View
	Local oStructZZ3 := FWFormStruct( 2 , 'ZZ2' )

	// Interface de visualiza��o constru�da
	Local oView := FWFormView():New()

	// Objeto do model a se associar a view.
	oView:SetModel( oModel )
		
	oView:AddField( 'VIEW_ZZ2' , oStructZZ3 , 'ZZ2MASTER' )
	
	//Adiciona um titulo para o formul�rio
	oView:EnableTitleView( 'VIEW_ZZ2' , STR0001 )
			
	oView:CreateHorizontalBox( 'TELAZZ2' , 100 )
	// Associa um View a um box
	oView:SetOwnerView( 'VIEW_ZZ2' , 'TELAZZ2' )

Return oView

//---------------------------------------------------------------------
/*/{Protheus.doc} fMPosValid
P�s-valida��o do modelo de dados.

@author Eloisa Anibaletto
@since 08/09/2022

@param oModel - Objeto do modelo de dados (Obrigat�rio)

@return L�gico - Retorna verdadeiro caso validacoes estejam corretas
/*/
//---------------------------------------------------------------------
Static Function fMPosVal( oModel )
    
	Local lRet			:= .T.
	
	Local aAreaZZ2		:= ZZ2->( GetArea() )

	Local nOperation	:= oModel:GetOperation() // Opera��o de a��o sobre o Modelo

	Private aCHKSQL 	:= {} // Vari�vel para consist�ncia na exclus�o (via SX9)
	Private aCHKDEL 	:= {} // Vari�vel para consist�ncia na exclus�o (via Cadastro)

	aCHKSQL := NGRETSX9( "ZZ2" )

	aAdd(aCHKDEL, { "ZZ2->ZZ2_MATAL" , "ZZ5" , 2 } )

	If nOperation == 5 //Exclus�o

		If !NGCHKDEL( "ZZ2" )
			lRet := .F.
		EndIf

		If lRet .And. !NGVALSX9( "ZZ2" , {} , .T. , .T. )
			lRet := .F.
		EndIf

	EndIf

	RestArea( aAreaZZ2 ) 

Return lRet
