#include "esa007.ch"
#include "PROTHEUS.CH"
#include "FWMVCDEF.CH"

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA007M
Monta a rotina de notas em MVC

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//--------------------------------------------------------------------- 
Function ESA007M()  
	
	// Armazena as variáveis
	//Local aNGBEGINPRM := NGBEGINPRM( _nVERSAO )
	
	Local oBrowse
		
		oBrowse := FWMBrowse():New()
			oBrowse:SetAlias( 'ZZ7' )			
			oBrowse:SetMenuDef( 'ESA007M' )	
			oBrowse:SetDescription( STR0001 )
		oBrowse:Activate()
		
		// Devolve as variáveis armazenadas
		//NGRETURNPRM(aNGBEGINPRM)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} ESA007M
Definição do Menu (padrão MVC).

@author Eloisa Anibaletto
@since 13/09/2022

@return aRotina array com o Menu MVC
/*/
//--------------------------------------------------------------------- 
Static Function MenuDef()
//Inicializa MenuDef com todas as opções
	Local aRotina := {}

	aAdd( aRotina, { STR0002, 'ViewDef.ESA007M', 0, 1, 0 } ) // Pesquisar
	aAdd( aRotina, { STR0003, 'ViewDef.ESA007M', 0, 2, 0 } ) // Visualizar
    aAdd( aRotina, { STR0004, 'ViewDef.ESA007M', 0, 3, 0 } ) // Incluir
    aAdd( aRotina, { STR0005, 'ViewDef.ESA007M', 0, 4, 0 } ) // Alterar
    aAdd( aRotina, { STR0006, 'ViewDef.ESA007M', 0, 5, 0 } ) // Excluir

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
    
    Local bPosZZ6 := { | cCampo | Posicione( 'ZZ6', 1, xFilial( 'ZZ6', cFilAnt ) + M->ZZ7_DISC, cCampo ) }

	Local bPosZZ2 := { | cCampo | Posicione( 'ZZ2', 1, xFilial( 'ZZ2', cFilAnt ) + M->ZZ7_MATAL, cCampo ) }

    // Cria a estrutura a ser usada no Modelo de Dados
	Local oStructZZ7 := FWFormStruct( 1 ,'ZZ7' )
	
	// Modelo de dados que será construído
	Local oModel := MPFormModel():New( 'ESA007M' ,  , { | oModel | fMPosVal( oModel ) } /*bPost*/ , /*bCommit*/ , /*bCancel*/ )

	oStructZZ7:AddTrigger( 'ZZ7_DISC', 'ZZ7_TURMA'  , { || .T. }, { || Eval( bPosZZ6, 'ZZ6_TURMA' ) } )
    oStructZZ7:AddTrigger( 'ZZ7_DISC', 'ZZ7_DESCT'  , { || .T. }, { || Eval( bPosZZ6, 'ZZ6_DESCT' ) } )
    oStructZZ7:AddTrigger( 'ZZ7_DISC', 'ZZ7_CODMAT' , { || .T. }, { || Eval( bPosZZ6, 'ZZ6_CODMAT' ) } )
    oStructZZ7:AddTrigger( 'ZZ7_DISC', 'ZZ7_DESCM'  , { || .T. }, { || Eval( bPosZZ6, 'ZZ6_DESCM' ) } )
    oStructZZ7:AddTrigger( 'ZZ7_DISC', 'ZZ7_MAT'    , { || .T. }, { || Eval( bPosZZ6, 'ZZ6_MAT' ) } )
    oStructZZ7:AddTrigger( 'ZZ7_DISC', 'ZZ7_NOMEP'  , { || .T. }, { || Eval( bPosZZ6, 'ZZ6_NOMEP' ) } )
    oStructZZ7:AddTrigger( 'ZZ7_MATAL', 'ZZ7_NOMEAL', { || .T. }, { || Eval( bPosZZ2, 'ZZ2_NOME' ) } )

	oModel:AddFields( 'ZZ7MASTER' , Nil , oStructZZ7 )
        
	oModel:SetPrimaryKey( { 'ZZ7_FILIAL', 'ZZ7_DATA' } )
		
	oModel:SetDescription( STR0001 ) 
			
	oModel:GetModel( 'ZZ7MASTER' ):SetDescription( STR0001 ) 
			
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
	Local oModel := FWLoadModel( 'ESA007M' )

	// Cria a estrutura a ser usada na View
	Local oStructZZ7 := FWFormStruct( 2 , 'ZZ7' )

	// Interface de visualização construída
	Local oView := FWFormView():New()

		// Objeto do model a se associar a view.
	oView:SetModel( oModel )
		
	oView:AddField( 'VIEW_ZZ7' , oStructZZ7 , 'ZZ7MASTER' )

	//Adiciona um titulo para o formulário
	oView:EnableTitleView( 'VIEW_ZZ7' , STR0001 )
			
	oView:CreateHorizontalBox( 'TELAZZ7' , 100 )
    
	// Associa um View a um box
	oView:SetOwnerView( 'VIEW_ZZ7' , 'TELAZZ7' )

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
	
	Local aAreaZZ7		:= ZZ7->( GetArea() )

	Local nOperation	:= oModel:GetOperation() // Operação de ação sobre o Modelo

	Private aCHKSQL 	:= {} // Variável para consistência na exclusão (via SX9)

	aCHKSQL := NGRETSX9( "ZZ7" )

	If nOperation == 5 //Exclusão

		If !NGCHKDEL( "ZZ7" )
			lRet := .F.
		EndIf

		If lRet .And. !NGVALSX9( "ZZ7" , {} , .T. , .T. )
			lRet := .F.
		EndIf

	EndIf

	RestArea( aAreaZZ7 ) 

Return lRet

///---------------------------------------------------------------------
/*/{Protheus.doc} ValNota
Função que retorna uma validação do valor de nota

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValNota()

    Local nNota := M->ZZ7_NOTA

    If (nNota < 0) .Or. (nNota > 10.0) 
        MsgStop( "Valor da nota incorreto", "ATENÇÃO" )
        Return .F.
    EndIf 

Return .T.

///---------------------------------------------------------------------
/*/{Protheus.doc} ValCodTu
Função que retorna no inic browser o código da turma 

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValCodTu()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ6" ) ) ), xFilial( "ZZ6" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ6->( dbSeek( xFilial( "ZZ6", cFil ) + ZZ7->ZZ7_DISC ) ), ZZ6->ZZ6_TURMA, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValDesTu
Função que retorna no inic browser a descrição da turma 

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValDesTu()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ6" ) ) ), xFilial( "ZZ6" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ6->( dbSeek( xFilial( "ZZ6", cFil ) + ZZ7->ZZ7_DISC ) ), ZZ6->ZZ6_DESCT, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValCodMa
Função que retorna no inic browser o código da matéria 

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValCodMa()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ6" ) ) ), xFilial( "ZZ6" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ6->( dbSeek( xFilial( "ZZ6", cFil ) + ZZ7->ZZ7_DISC ) ), ZZ6->ZZ6_CODMAT, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValCodMa
Função que retorna no inic browser a descrição da matéria 

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValDesMa()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ6" ) ) ), xFilial( "ZZ6" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ6->( dbSeek( xFilial( "ZZ6", cFil ) + ZZ7->ZZ7_DISC ) ), ZZ6->ZZ6_DESCM, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValMatP
Função que retorna no inic browser a matrícula do professor 

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValMatP()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ6" ) ) ), xFilial( "ZZ6" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ6->( dbSeek( xFilial( "ZZ6", cFil ) + ZZ7->ZZ7_DISC ) ), ZZ6->ZZ6_MAT, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValNomeP
Função que retorna no inic browser o nome do professor 

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValNomeP()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ6" ) ) ), xFilial( "ZZ6" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ6->( dbSeek( xFilial( "ZZ6", cFil ) + ZZ7->ZZ7_DISC ) ), ZZ6->ZZ6_NOMEP, "" )

///---------------------------------------------------------------------
/*/{Protheus.doc} ValNomeA
Função que retorna no inic browser o nome do aluno

@author Eloisa Anibaletto
@since 13/09/2022
/*/
//---------------------------------------------------------------------
Static Function ValNomeA()

	Local cFil := IIf( Len( AllTrim( ZZ7->ZZ7_FILIAL ) ) != Len( AllTrim( xFilial( "ZZ2" ) ) ), xFilial( "ZZ2" ), ZZ7->ZZ7_FILIAL )

Return IIf( ZZ2->( dbSeek( xFilial( "ZZ2", cFil ) + ZZ7->ZZ7_MATAL ) ), ZZ2->ZZ2_NOME, "" )
