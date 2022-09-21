#include "NGA002.ch"
#include "PROTHEUS.CH"
#include "FWMVCDEF.CH"

//---------------------------------------------------------------------
/*/{Protheus.doc} NGA002M
Monta a rotina de ficha m�dica em MVC

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//--------------------------------------------------------------------- 
Function NGA002M()  
	
	// Armazena as vari�veis
	//Local aNGBEGINPRM := NGBEGINPRM( _nVERSAO )
	
	Local oBrowse
		
		oBrowse := FWMBrowse():New()
			oBrowse:SetAlias( 'ZA2' )			
			oBrowse:SetMenuDef( 'NGA002M' )	
			oBrowse:SetDescription( STR0001 )
		oBrowse:Activate()
		
		// Devolve as vari�veis armazenadas
		//NGRETURNPRM(aNGBEGINPRM)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} NGA002M
Defini��o do Menu (padr�o MVC).

@author Eloisa Anibaletto
@since 13/09/2022

@return aRotina array com o Menu MVC
/*/
//--------------------------------------------------------------------- 
Static Function MenuDef()
//Inicializa MenuDef com todas as op��es
	Local aRotina := {}

	aAdd( aRotina, { STR0002, 'ViewDef.NGA002M', 0, 1, 0 } ) // Pesquisar
	aAdd( aRotina, { STR0003, 'ViewDef.NGA002M', 0, 2, 0 } ) // Visualizar
    aAdd( aRotina, { STR0004, 'ViewDef.NGA002M', 0, 3, 0 } ) // Incluir
    aAdd( aRotina, { STR0005, 'ViewDef.NGA002M', 0, 4, 0 } ) // Alterar
    aAdd( aRotina, { STR0006, 'ViewDef.NGA002M', 0, 5, 0 } ) // Excluir

Return aRotina

//---------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Defini��o do Modelo (padr�o MVC).

@author Eloisa Anibaletto
@since 13/09/2022

@return oModel objeto do Modelo MVC
/*/
//---------------------------------------------------------------------
Static Function ModelDef()

    Local bPosZA1 := { | cCampo | Posicione( 'ZA1', 1, xFilial( 'ZA1', cFilAnt ) + M->ZA2_MAT, cCampo ) }
    // Cria a estrutura a ser usada no Modelo de Dados
	Local oStructZA2 := FWFormStruct( 1 ,'ZA2' )
	
	// Modelo de dados que ser� constru�do
	Local oModel := MPFormModel():New( 'NGA002M' ,  , { | oModel | fMPosVal( oModel ) } /*bPost*/ , /*bCommit*/ , /*bCancel*/ )

    oStructZA2:AddTrigger( 'ZA2_MAT', 'ZA2_NOME'    , { || .T. }, { || Eval( bPosZA1, 'ZA1_NOME' ) } )
    oStructZA2:AddTrigger( 'ZA2_MAT', 'ZA2_DTNASC'  , { || .T. }, { || Eval( bPosZA1, 'ZA1_DTNASC' ) } )
    oStructZA2:AddTrigger( 'ZA2_MAT', 'ZA2_SEXO'    , { || .T. }, { || Eval( bPosZA1, 'ZA1_SEXO' ) } )
    oStructZA2:AddTrigger( 'ZA2_MAT', 'ZA2_RG'      , { || .T. }, { || Eval( bPosZA1, 'ZA1_RG' ) } )

	oModel:AddFields( 'ZA2MASTER' , Nil , oStructZA2 )
		
    oModel:SetPrimaryKey( { 'ZA2_FILIAL', 'ZA2_NUMFIC' } )
		
	oModel:SetDescription( STR0001 ) 
			
	oModel:GetModel( 'ZA2MASTER' ):SetDescription( STR0001 ) 
			
Return oModel

//---------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Defini��o da View (padr�o MVC).

@author Eloisa Anibaletto
@since 13/09/2022

@return oView objeto da View MVC
/*/
//---------------------------------------------------------------------
Static Function ViewDef()
	
	// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
	Local oModel := FWLoadModel( 'NGA002M' )
	// Cria a estrutura a ser usada na View
	Local oStructZA2 := FWFormStruct( 2 , 'ZA2' )
	// Interface de visualiza��o constru�da
	Local oView := FWFormView():New()
		// Objeto do model a se associar a view.
	oView:SetModel( oModel )
		
	oView:AddField( 'VIEW_ZA2' , oStructZA2 , 'ZA2MASTER' )
			//Adiciona um titulo para o formul�rio
	oView:EnableTitleView( 'VIEW_ZA2' , STR0001 )
			
	oView:CreateHorizontalBox( 'TELAZA2' , 100 )
		// Associa um View a um box
	oView:SetOwnerView( 'VIEW_ZA2' , 'TELAZA2' )

Return oView

//---------------------------------------------------------------------
/*/{Protheus.doc} fMPosValid
P�s-valida��o do modelo de dados.

@author Eloisa Anibaletto
@since 13/09/2022

@param oModel - Objeto do modelo de dados (Obrigat�rio)

@return L�gico - Retorna verdadeiro caso validacoes estejam corretas
/*/
//---------------------------------------------------------------------
Static Function fMPosVal( oModel )
    
	Local lRet			:= .T.
	
	Local aAreaZA2		:= ZA2->( GetArea() )

	Local nOperation	:= oModel:GetOperation() // Opera��o de a��o sobre o Modelo

	Private aCHKSQL 	:= {} // Vari�vel para consist�ncia na exclus�o (via SX9)
	Private aCHKDEL 	:= {} // Vari�vel para consist�ncia na exclus�o (via Cadastro)

	aCHKSQL := NGRETSX9( "ZA2" )

	aAdd(aCHKDEL, { "ZA2->ZA2_NUMFIC" , "ZA4" , 2 } )

	If nOperation == 5 //Exclus�o

		If !NGCHKDEL( "ZA2" )
			lRet := .F.
		EndIf

		If lRet .And. !NGVALSX9( "ZA2" , {} , .T. , .T. )
			lRet := .F.
		EndIf

	EndIf

	RestArea( aAreaZA2 ) 

Return lRet

///---------------------------------------------------------------------
/*/{Protheus.doc} ValNome
Fun��o que retorna no browser o nome do funcion�rio

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValNome()

	Local cFil := IIf( Len( AllTrim( ZA2->ZA2_FILIAL ) ) != Len( AllTrim( xFilial( "ZA1" ) ) ), xFilial( "ZA1" ), ZA2->ZA2_FILIAL )

Return IIf( ZA1->( dbSeek( xFilial( "ZA1", cFil ) + ZA2->ZA2_MAT ) ), ZA1->ZA1_NOME, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDtNas
Fun��o que retorna no browser a data de nascimento 

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValDtNas()

	Local cFil := IIf( Len( AllTrim( ZA2->ZA2_FILIAL ) ) != Len( AllTrim( xFilial( "ZA1" ) ) ), xFilial( "ZA1" ), ZA2->ZA2_FILIAL )

Return IIf( ZA1->( dbSeek( xFilial( "ZA1", cFil ) + ZA2->ZA2_MAT ) ), ZA1->ZA1_DTNASC, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValSexo
Fun��o que retorna no browser o sexo 

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValSexo()

	Local cFil := IIf( Len( AllTrim( ZA2->ZA2_FILIAL ) ) != Len( AllTrim( xFilial( "ZA1" ) ) ), xFilial( "ZA1" ), ZA2->ZA2_FILIAL )

Return IIf( ZA1->( dbSeek( xFilial( "ZA1", cFil ) + ZA2->ZA2_MAT ) ), ZA1->ZA1_SEXO, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValRg
Fun��o que retorna no browser o RG 

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValRg()

	Local cFil := IIf( Len( AllTrim( ZA2->ZA2_FILIAL ) ) != Len( AllTrim( xFilial( "ZA1" ) ) ), xFilial( "ZA1" ), ZA2->ZA2_FILIAL )

Return IIf( ZA1->( dbSeek( xFilial( "ZA1", cFil ) + ZA2->ZA2_MAT ) ), ZA1->ZA1_RG, "" )
