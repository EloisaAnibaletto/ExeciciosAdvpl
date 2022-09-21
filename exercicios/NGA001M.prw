#include "NGA001.ch"
#include "PROTHEUS.CH"
#include "FWMVCDEF.CH"

//---------------------------------------------------------------------
/*/{Protheus.doc} NGA001M
Monta a rotina de funcion�rios em MVC

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//--------------------------------------------------------------------- 
Function NGA001M()  
	
	// Armazena as vari�veis
	//Local aNGBEGINPRM := NGBEGINPRM( _nVERSAO )
	
	Local oBrowse
		
		oBrowse := FWMBrowse():New()
			oBrowse:SetAlias( 'ZA1' )			
			oBrowse:SetMenuDef( 'NGA001M' )	
			oBrowse:SetDescription( STR0001 )
		oBrowse:Activate()
		
		// Devolve as vari�veis armazenadas
		//NGRETURNPRM(aNGBEGINPRM)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} NGA001M
Defini��o do Menu (padr�o MVC).

@author Eloisa Anibaletto
@since 13/09/2022

@return aRotina array com o Menu MVC
/*/
//--------------------------------------------------------------------- 
Static Function MenuDef()
//Inicializa MenuDef com todas as op��es
	Local aRotina := {}

	aAdd( aRotina, { STR0002, 'ViewDef.NGA001M', 0, 1, 0 } ) // Pesquisar
	aAdd( aRotina, { STR0003, 'ViewDef.NGA001M', 0, 2, 0 } ) // Visualizar
    aAdd( aRotina, { STR0004, 'ViewDef.NGA001M', 0, 3, 0 } ) // Incluir
    aAdd( aRotina, { STR0005, 'ViewDef.NGA001M', 0, 4, 0 } ) // Alterar
    aAdd( aRotina, { STR0006, 'ViewDef.NGA001M', 0, 5, 0 } ) // Excluir

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
    
    // Cria a estrutura a ser usada no Modelo de Dados
	Local oStructZA1 := FWFormStruct( 1 ,'ZA1' )
	
	// Modelo de dados que ser� constru�do
	Local oModel := MPFormModel():New( 'NGA001M' ,  , { | oModel | fMPosVal( oModel ) } /*bPost*/ , /*bCommit*/ , /*bCancel*/ )

	oModel:AddFields( 'ZA1MASTER' , Nil , oStructZA1 )
		
    oModel:SetPrimaryKey( { 'ZA1_FILIAL', 'ZA1_MAT' } )
		
	oModel:SetDescription( STR0001 ) 
			
	oModel:GetModel( 'ZA1MASTER' ):SetDescription( STR0001 ) 
			
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
	Local oModel := FWLoadModel( 'NGA001M' )
	// Cria a estrutura a ser usada na View
	Local oStructZA1 := FWFormStruct( 2 , 'ZA1' )
	// Interface de visualiza��o constru�da
	Local oView := FWFormView():New()
		// Objeto do model a se associar a view.
	oView:SetModel( oModel )
		
	oView:AddField( 'VIEW_ZA1' , oStructZA1 , 'ZA1MASTER' )
			//Adiciona um titulo para o formul�rio
	oView:EnableTitleView( 'VIEW_ZA1' , STR0001 )
			
	oView:CreateHorizontalBox( 'TELAZA1' , 100 )
		// Associa um View a um box
	oView:SetOwnerView( 'VIEW_ZA1' , 'TELAZA1' )

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
	
	Local aAreaZA1		:= ZA1->( GetArea() )

	Local nOperation	:= oModel:GetOperation() // Opera��o de a��o sobre o Modelo

	Private aCHKSQL 	:= {} // Vari�vel para consist�ncia na exclus�o (via SX9)
	Private aCHKDEL 	:= {} // Vari�vel para consist�ncia na exclus�o (via Cadastro)

	aCHKSQL := NGRETSX9( "ZA1" )

	aAdd(aCHKDEL, { "ZA1->ZA1_MAT" , "ZA2" , 2 } )

	If nOperation == 5 //Exclus�o

		If !NGCHKDEL( "ZA1" )
			lRet := .F.
		EndIf

		If lRet .And. !NGVALSX9( "ZA1" , {} , .T. , .T. )
			lRet := .F.
		EndIf

	EndIf

	RestArea( aAreaZA1 ) 

Return lRet

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDtN
Fun��o que valida que a data de admiss�o n�o pode ser menor que a data 
de nascimento

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValDatN()

    Local dAdmi := oMaster:GetValue( 'ZA1_DTADMI' )
    Local dNasc := oMaster:GetValue( 'ZA1_DTNASC' ) 

    If dAdmi < dNasc 
        MsgStop( "Data de admiss�o n�o pode ser menor que data de nascimento!", "ATEN��O" )
        Return .F.
    EndIf 

Return .T.

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDtD
Fun��o que valida que a data de demiss�o n�o pode ser menor que a data 
de admiss�o

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValDatD()

    Local dDemi := oMaster:GetValue( 'ZA1_DTDEMI' ) 
    Local dAdmi := oMaster:GetValue( 'ZA1_DTADMI' ) 

    If dDemi < dAdmi
        MsgStop( "Data de demiss�o n�o pode ser menor que data de admiss�o!", "ATEN��O" )
        Return .F.
    EndIf 

Return .T.
