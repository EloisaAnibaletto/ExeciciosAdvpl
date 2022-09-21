#include "esa001.ch"
#include "PROTHEUS.CH"
#include "FWMVCDEF.CH"

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA001M
Monta a rotina de professores em MVC

@author Eloisa Anibaletto
@since 08/09/2022
/*/
//--------------------------------------------------------------------- 
Function ESA001M()  
	
	// Armazena as vari�veis
	//Local aNGBEGINPRM := NGBEGINPRM( _nVERSAO )
	
	Local oBrowse
		
		oBrowse := FWMBrowse():New()
			oBrowse:SetAlias( 'ZZ1' )			
			oBrowse:SetMenuDef( 'ESA001M' )	
			oBrowse:SetDescription( STR0001 )
		oBrowse:Activate()
		
		// Devolve as vari�veis armazenadas
		//NGRETURNPRM(aNGBEGINPRM)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA001M
Defini��o do Menu (padr�o MVC).

@author Eloisa Anibaletto
@since 08/09/2022

@return aRotina array com o Menu MVC
/*/
//--------------------------------------------------------------------- 
Static Function MenuDef()
//Inicializa MenuDef com todas as op��es
	Local aRotina := {}

	aAdd( aRotina, { STR0002, 'ViewDef.ESA001M', 0, 1, 0 } ) // Pesquisar
	aAdd( aRotina, { STR0003, 'ViewDef.ESA001M', 0, 2, 0 } ) // Visualizar
    aAdd( aRotina, { STR0004, 'ViewDef.ESA001M', 0, 3, 0 } ) // Incluir
    aAdd( aRotina, { STR0005, 'ViewDef.ESA001M', 0, 4, 0 } ) // Alterar
    aAdd( aRotina, { STR0006, 'ViewDef.ESA001M', 0, 5, 0 } ) // Excluir

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
	Local oStructZZ1 := FWFormStruct( 1 ,'ZZ1' )
	
	// Modelo de dados que ser� constru�do
	Local oModel := MPFormModel():New( 'ESA001M' ,  , { | oModel | fMPosVal( oModel ) } /*bPost*/ , /*bCommit*/ , /*bCancel*/ )

	oModel:AddFields( 'ZZ1MASTER' , Nil , oStructZZ1 )
		
	oModel:SetPrimaryKey( { 'ZZ1_FILIAL', 'ZZ1_MAT' } )
		
	oModel:SetDescription( STR0001 ) 
			
	oModel:GetModel( 'ZZ1MASTER' ):SetDescription( STR0001 ) 
			
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
	Local oModel := FWLoadModel( 'ESA001M' )

	// Cria a estrutura a ser usada na View
	Local oStructZZ1 := FWFormStruct( 2 , 'ZZ1' )

	// Interface de visualiza��o constru�da
	Local oView := FWFormView():New()
	
	// Objeto do model a se associar a view.
	oView:SetModel( oModel )
		
	oView:AddField( 'VIEW_ZZ1' , oStructZZ1 , 'ZZ1MASTER' )

	//Adiciona um titulo para o formul�rio
	oView:EnableTitleView( 'VIEW_ZZ1' , STR0001 )
			
	oView:CreateHorizontalBox( 'TELAZZ1' , 100 )

	// Associa um View a um box
	oView:SetOwnerView( 'VIEW_ZZ1' , 'TELAZZ1' )

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
	
	Local aAreaZZ1		:= ZZ1->( GetArea() )

	Local nOperation	:= oModel:GetOperation() // Opera��o de a��o sobre o Modelo

	Private aCHKSQL 	:= {} // Vari�vel para consist�ncia na exclus�o (via SX9)
	Private aCHKDEL 	:= {} // Vari�vel para consist�ncia na exclus�o (via Cadastro)

	aCHKSQL := NGRETSX9( "ZZ1" )

	aAdd(aCHKDEL, { "ZZ1->ZZ1_MAT" , "ZZ6" , 3 } )

	If nOperation == 5 //Exclus�o

		If !NGCHKDEL( "ZZ1" )
			lRet := .F.
		EndIf

		If lRet .And. !NGVALSX9( "ZZ1" , {} , .T. , .T. )
			lRet := .F.
		EndIf

	EndIf

	RestArea( aAreaZZ1 ) 

Return lRet

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDtAdm
Fun��o que valida que a data de admiss�o n�o pode ser menor que a data 
de nascimento

@author Eloisa Anibaletto
@since 08/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValDtAdm()

    Local dAdmi := oMaster:GetValue( 'ZZ1_DTADMI' )
    Local dNasc := oMaster:GetValue( 'ZZ1_DTNASC' ) 

    If dAdmi < dNasc 
        MsgStop( "Data de admiss�o n�o pode ser menor que data de nascimento!", "ATEN��O" )
        Return .F.
    EndIf 

Return .T.

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDtDem
Fun��o que valida que a data de demiss�o n�o pode ser menor que a data 
de admiss�o

@author Eloisa Anibaletto
@since 08/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValDtDem()

    Local dDemi := oMaster:GetValue( 'ZZ1_DTDEMI' ) 
    Local dAdmi := oMaster:GetValue( 'ZZ1_DTADMI' ) 

    If dDemi < dAdmi
        MsgStop( "Data de demiss�o n�o pode ser menor que data de admiss�o!", "ATEN��O" )
        Return .F.
    EndIf 

Return .T.
