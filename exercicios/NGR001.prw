#Include 'protheus.ch'
#Include 'NGR001.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} NGR001
Monta impressão de relatório

@author Eloisa Anibaletto
@since 31/08/2022

/*/
//-------------------------------------------------------------------
User Function NGR001()

	Local oReport

	Private aCampo := {}

	oReport := U_RepDef()
	oReport:SetPortrait()
	oReport:PrintDialog()

Return

User Function RepDef()

	Local oCell
	Local oSection
	Local oReport := TReport():New(;
		"NGR001",;
		OEMTOANSI( STR0001 ),;//Relatório de Exames dos Funcionários
	"NGR001",;
		{ | oReport | U_RepPrint( oReport ) },;
		STR0002;//Descrição do Relatório
	)

	oReport:ShowParamPage()
	oReport:lParamPage := .F.
	oReport:lHeaderVisible := .F.

	oSection := TRSection():New( oReport, "", "" )
	oSection2 := TRSection():New( oReport, "", "" )

	oCell := TRCell():New( oSection, STR0003 , NIL, NIL, NIL, 13, NIL, { || aCampo [ nPos, 01 ] } ) //Ficha Médica
	oCell := TRCell():New( oSection, STR0004 , NIL, NIL, NIL, 40, NIL, { || aCampo [ nPos, 02 ] } ) //Nome do Funcionário
	oCell := TRCell():New( oSection, STR0005 , NIL, NIL, NIL, 08, NIL, { || aCampo [ nPos, 03 ] } ) //Cargo
	oCell := TRCell():New( oSection, STR0006 , NIL, NIL, NIL, 30, NIL, { || aCampo [ nPos, 04 ] } ) //Setor
	oCell := TRCell():New( oSection, STR0007 , NIL, NIL, NIL, 08, NIL, { || aCampo [ nPos, 05 ] } ) //Data Admissão
	oCell := TRCell():New( oSection, STR0008 , NIL, NIL, NIL, 25, NIL, { || aCampo [ nPos, 06 ] } ) //Exame
	oCell := TRCell():New( oSection, STR0009 , NIL, NIL, NIL, 22, NIL, { || aCampo [ nPos, 07 ] } ) //Descrição do Exame
	oCell := TRCell():New( oSection, STR0010 , NIL, NIL, NIL, 10, NIL, { || aCampo [ nPos, 08 ] } ) //Dt. Prevista
	oCell := TRCell():New( oSection, STR0011 , NIL, NIL, NIL, 11, NIL, { || aCampo [ nPos, 09 ] } ) //Realização
	oCell := TRCell():New( oSection, STR0012 , NIL, NIL, NIL, 40, NIL, { || aCampo [ nPos, 10 ] } ) //Resultado

	//oCell := TRCell():New( oSection2, STR0013 , NIL, NIL, NIL, 40, NIL, { || aCampo [ nPos, 11 ] } ) //Exames no Período
	oCell := TRCell():New( oSection2, "", Nil, Nil, Nil, 40, Nil, { || STR0014 + CValToChar( ( Len( aExNCount ) ) ) } ) //Exames Normais
	oCell := TRCell():New( oSection2, "", NIL, NIL, NIL, 40, NIL, { || STR0015 + CValToChar( ( Len( aExACount ) ) ) } ) //Exames Alterados
	oCell := TRCell():New( oSection2, "", NIL, NIL, NIL, 40, NIL, { || STR0016 + CValToChar( ( Len( aTotalECount ) ) ) } ) //Total

Return oReport

User Function RepPrint( oReport )

	Local ni := 0

	Local oSection := oReport:Section( 1 )
	Local oSection2 := oReport:Section( 2 )

	Private aExNCount := {}
	Private aExACount := {}
	Private aTotalECount := {}

	Private nPos := 0

	dbSelectArea( 'ZA4' )
	dbSetOrder( 1 )

	If dbSeek( xFilial( 'ZA4' ) + mv_par01 )

		While ( 'ZA4' )->( !Eof() ) .And. xFilial( 'ZA4' ) == ZA4->ZA4_FILIAL .And.;
		ZA4->ZA4_NUMFIC >= mv_par01 .And. ZA4->ZA4_NUMFIC <= mv_par02

			If !Empty( ZA4->ZA4_EXAME ) .And. ( ZA4->ZA4_EXAME < mV_par03 .Or. ZA4->ZA4_EXAME > mv_par04 )

				( 'ZA4' )->( Dbskip() )

				Loop

			EndIf

			If !Empty( ZA4->ZA4_DTPREV ) .And. ( ZA4->ZA4_DTPREV < mV_par05 .Or. ZA4->ZA4_DTPREV > mv_par06 )

				( 'ZA4' )->( Dbskip() )

				Loop

			EndIf

			If !Empty( ZA4->ZA4_DTREAL ) .And. mv_par07 == 1

				( 'ZA4' )->( Dbskip() )

				Loop

			EndIf

			If Empty( ZA4->ZA4_DTREAL ) .And. mv_par07 == 2

				( 'ZA4' )->( Dbskip() )

				Loop

			EndIf

			If !Empty( ZA4->ZA4_DTREAL ) .And. Empty( ZA4->ZA4_DTREAL ) .And. mv_par07 == 3

				( 'ZA4' )->( Dbskip() )

				Loop

			EndIf

			dbSelectArea( 'ZA2' )
			dbSetOrder( 1 )

			If dbSeek( xFilial( 'ZA2' ) + ZA4->ZA4_NUMFIC )

				DbSelectArea( 'ZA1' )
				DbSetOrder( 1 )

				If DbSeek( xFilial( 'ZA1' ) + ZA2->ZA2_MAT )

					aAdd( aCampo, {;
						ZA4->ZA4_NUMFIC,;
						ZA1->ZA1_NOME,;
						ZA1->ZA1_CARGO,;
						ZA1->ZA1_SETOR,;
						ZA1->ZA1_DTADMI,;
						ZA4->ZA4_EXAME,;
						Posicione( "ZA3", 1, xFilial( "ZA3" ) + ZA4->ZA4_EXAME, "ZA3_DESCRI" ),;
						ZA4->ZA4_DTPREV,;
						ZA4->ZA4_DTREAL,;
						ZA4->ZA4_RESULT;
					} )
					
					If ZA4->ZA4_RESULT == '1'
						Aadd( aExNCount, ZA4->ZA4_RESULT )
					EndIf

					If ZA4->ZA4_RESULT == '2'
						Aadd( aExACount, ZA4->ZA4_RESULT )
					EndIf

					If aScan( aTotalECount, ZA4->ZA4_EXAME ) == 0
						Aadd( aTotalECount, ZA4->ZA4_EXAME )
					EndIf

				EndIf

			EndIf

			( 'ZA4' )->( Dbskip() )

		End

	EndIf

	oSection:Init( .F. )

	For ni := 1 To Len( aCampo )

		nPos := ni

		oSection:PrintLine()

	Next

	oSection:Finish()

	oSection2:Init( .F. )

	oSection2:PrintLine()

	oSection2:Finish()

Return


