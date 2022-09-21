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
	
	// Armazena as variáveis
	//Local aNGBEGINPRM := NGBEGINPRM( _nVERSAO )
	
	Local oBrowse
		
		oBrowse := FWMBrowse():New()
			oBrowse:SetAlias( 'ZZ1' )			
			oBrowse:SetMenuDef( 'ESA001M' )	
			oBrowse:SetDescription( STR0001 )
		oBrowse:Activate()
		
		// Devolve as variáveis armazenadas
		//NGRETURNPRM(aNGBEGINPRM)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA001M
Definição do Menu (padrão MVC).

@author Eloisa Anibaletto
@since 08/09/2022

@return aRotina array com o Menu MVC
/*/
//--------------------------------------------------------------------- 
Static Function MenuDef()
//Inicializa MenuDef com todas as opções
	Local aRotina := {}

	aAdd( aRotina, { STR0002, 'ViewDef.ESA001M', 0, 1, 0 } ) // Pesquisar
	aAdd( aRotina, { STR0003, 'ViewDef.ESA001M', 0, 2, 0 } ) // Visualizar
    aAdd( aRotina, { STR0004, 'ViewDef.ESA001M', 0, 3, 0 } ) // Incluir
    aAdd( aRotina, { STR0005, 'ViewDef.ESA001M', 0, 4, 0 } ) // Alterar
    aAdd( aRotina, { STR0006, 'ViewDef.ESA001M', 0, 5, 0 } ) // Excluir

Return aRotina

//---------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do Modelo (padrão MVC).

@author Eloisa Anibaletto
@since 08/09/2022

@return oModel objeto do Modelo MVC
/*/
//---------------------------------------------------------------------
Static Function ModelDef()
    
    // Cria a estrutura a ser usada no Modelo de Dados
	Local oStructZZ1 := FWFormStruct( 1 ,'ZZ1' )
	
	// Modelo de dados que será construído
	Local oModel := MPFormModel():New( 'ESA001M' ,  , { | oModel | fMPosVal( oModel ) } /*bPost*/ , /*bCommit*/ , /*bCancel*/ )

	oModel:AddFields( 'ZZ1MASTER' , Nil , oStructZZ1 )
		
	oModel:SetPrimaryKey( { 'ZZ1_FILIAL', 'ZZ1_MAT' } )
		
	oModel:SetDescription( STR0001 ) 
			
	oModel:GetModel( 'ZZ1MASTER' ):SetDescription( STR0001 ) 
			
Return oModel

//---------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição da View (padrão MVC).

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

	// Interface de visualização construída
	Local oView := FWFormView():New()
	
	// Objeto do model a se associar a view.
	oView:SetModel( oModel )
		
	oView:AddField( 'VIEW_ZZ1' , oStructZZ1 , 'ZZ1MASTER' )

	//Adiciona um titulo para o formulário
	oView:EnableTitleView( 'VIEW_ZZ1' , STR0001 )
			
	oView:CreateHorizontalBox( 'TELAZZ1' , 100 )

	// Associa um View a um box
	oView:SetOwnerView( 'VIEW_ZZ1' , 'TELAZZ1' )

Return oView

//---------------------------------------------------------------------
/*/{Protheus.doc} fMPosValid
Pós-validação do modelo de dados.

@author Eloisa Anibaletto
@since 08/09/2022

@param oModel - Objeto do modelo de dados (Obrigatório)

@return Lígico - Retorna verdadeiro caso validacoes estejam corretas
/*/
//---------------------------------------------------------------------
Static Function fMPosVal( oModel )
    
	Local lRet			:= .T.
	
	Local aAreaZZ1		:= ZZ1->( GetArea() )

	Local nOperation	:= oModel:GetOperation() // Operação de ação sobre o Modelo

	Private aCHKSQL 	:= {} // Variável para consistência na exclusão (via SX9)
	Private aCHKDEL 	:= {} // Variável para consistência na exclusão (via Cadastro)

	aCHKSQL := NGRETSX9( "ZZ1" )

	aAdd(aCHKDEL, { "ZZ1->ZZ1_MAT" , "ZZ6" , 3 } )

	If nOperation == 5 //Exclusão

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
Função que valida que a data de admissão não pode ser menor que a data 
de nascimento

@author Eloisa Anibaletto
@since 08/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValDtAdm()

    Local dAdmi := oMaster:GetValue( 'ZZ1_DTADMI' )
    Local dNasc := oMaster:GetValue( 'ZZ1_DTNASC' ) 

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
@since 08/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValDtDem()

    Local dDemi := oMaster:GetValue( 'ZZ1_DTDEMI' ) 
    Local dAdmi := oMaster:GetValue( 'ZZ1_DTADMI' ) 

    If dDemi < dAdmi
        MsgStop( "Data de demissão não pode ser menor que data de admissão!", "ATENÇÃO" )
        Return .F.
    EndIf 

Return .T.
