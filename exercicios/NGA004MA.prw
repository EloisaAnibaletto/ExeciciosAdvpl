#include "NGA004A.ch"
#include "PROTHEUS.CH"
#include "FWMVCDEF.CH"

//---------------------------------------------------------------------
/*/{Protheus.doc} NGA004MA
Monta a rotina de exame de funcionário em MVC

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//--------------------------------------------------------------------- 
Function NGA004MA()  
	
	// Armazena as variáveis
	//Local aNGBEGINPRM := NGBEGINPRM( _nVERSAO )
	
	Local oBrowse
		
		oBrowse := FWMBrowse():New()
			oBrowse:SetAlias( 'ZA4' )			
			oBrowse:SetMenuDef( 'NGA004MA' )	
			oBrowse:SetDescription( STR0001 )
		oBrowse:Activate()
		
		// Devolve as variáveis armazenadas
		//NGRETURNPRM(aNGBEGINPRM)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} NGA004MA
Definição do Menu (padrão MVC).

@author Eloisa Anibaletto
@since 13/09/2022

@return aRotina array com o Menu MVC
/*/
//--------------------------------------------------------------------- 
Static Function MenuDef()
//Inicializa MenuDef com todas as opções
	Local aRotina := {}

	aAdd( aRotina, { STR0002, 'ViewDef.NGA004MA', 0, 1, 0 } ) // Pesquisar
	aAdd( aRotina, { STR0003, 'ViewDef.NGA004MA', 0, 2, 0 } ) // Visualizar
    aAdd( aRotina, { STR0004, 'ViewDef.NGA004MA', 0, 3, 0 } ) // Incluir
    aAdd( aRotina, { STR0005, 'ViewDef.NGA004MA', 0, 4, 0 } ) // Alterar
    aAdd( aRotina, { STR0006, 'ViewDef.NGA004MA', 0, 5, 0 } ) // Excluir

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

	Local bPosZA2 := { | cCampo | Posicione( 'ZA2', 1, xFilial( 'ZA2', cFilAnt ) + M->ZA4_NUMFIC, cCampo ) }

	Local bPosZA3 := { | cCampo | Posicione( 'ZA3', 1, xFilial( 'ZA3', cFilAnt ) + M->ZA4_EXAME, cCampo ) }

    // Cria a estrutura a ser usada no Modelo de Dados
	Local oStructZA4 := FWFormStruct( 1 ,'ZA4' )
	
	// Modelo de dados que será construído
	Local oModel := MPFormModel():New( 'NGA004MA' ,  , { | oModel | fMPosVal( oModel ) } /*bPost*/ , /*bCommit*/ , /*bCancel*/ )

	oStructZA4:AddTrigger( 'ZA4_NUMFIC', 'ZA4_NOME', { || .T. }, { || Eval( bPosZA2, 'ZA2_NOME' ) } )
	oStructZA4:AddTrigger( 'ZA4_EXAME', 'ZA4_DESEXA' , { || .T. }, { || Eval( bPosZA3, 'ZA3_DESCRI' ) } )

	oModel:AddFields( 'ZA4MASTER' , Nil , oStructZA4 )
        
	oModel:SetPrimaryKey( { 'ZA4_FILIAL', 'ZA4_DTPREV' } )
		
	oModel:SetDescription( STR0001 ) 
			
	oModel:GetModel( 'ZA4MASTER' ):SetDescription( STR0001 ) 
			
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
	Local oModel := FWLoadModel( 'NGA004MA' )

	// Cria a estrutura a ser usada na View
	Local oStructZA4 := FWFormStruct( 2 , 'ZA4' )

	// Interface de visualização construída
	Local oView := FWFormView():New()

	// Objeto do model a se associar a view.
	oView:SetModel( oModel )
	
	oView:AddField( 'VIEW_ZA4' , oStructZA4 , 'ZA4MASTER' )

	//Adiciona um titulo para o formulário
	oView:EnableTitleView( 'VIEW_ZA4' , STR0001 )
			
	oView:CreateHorizontalBox( 'TELAZA4' , 100 )
	
	// Associa um View a um box
	oView:SetOwnerView( 'VIEW_ZA4' , 'TELAZA4' )

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
	
	Local aAreaZA4		:= ZA4->( GetArea() )

	Local nOperation	:= oModel:GetOperation() // Operação de ação sobre o Modelo

	Private aCHKSQL 	:= {} // Variável para consistência na exclusão (via SX9)

	aCHKSQL := NGRETSX9( "ZA4" )

	If nOperation == 5 //Exclusão

		If !NGCHKDEL( "ZA4" )
			lRet := .F.
		EndIf

		If lRet .And. !NGVALSX9( "ZA4" , {} , .T. , .T. )
			lRet := .F.
		EndIf

	EndIf

	RestArea( aAreaZA4 ) 

Return lRet

///---------------------------------------------------------------------
/*/{Protheus.doc} NGANOME
Função que retorna o nome do funcionário 

@author Eloisa Anibaletto
@since 25/08/2022
/*/
//---------------------------------------------------------------------
Static Function NGANOME( cTipo )

Local cNumFic := IIf(cTipo == "X7", M->ZA4_NUMFIC, ZA4->ZA4_NUMFIC)
Local cRet := ""

	If !(Inclui .And. cTipo == "INIPAD")

		cRet := Posicione( "ZA1", 1, xFilial( "ZA1" ) +;
			Posicione( "ZA2", 1, xFilial( "ZA2" ) + cNumFic, "ZA2_MAT" ),;
			"ZA1_NOME" )

	EndIf

Return cRet

///---------------------------------------------------------------------
/*/{Protheus.doc} NGAEXA
Função que retorna a descrição do exame

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function NGAEXA()

	Local cFil := IIf( Len( AllTrim( ZA4->ZA4_FILIAL ) ) != Len( AllTrim( xFilial( "ZA3" ) ) ), xFilial( "ZA3" ), ZA4->ZA4_FILIAL )

Return IIf( ZA3->( dbSeek( xFilial( "ZA3", cFil ) + ZA4->ZA4_EXAME ) ), ZA3->ZA3_DESCRI, "" )
