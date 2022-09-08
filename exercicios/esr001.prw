#Include 'protheus.ch'
#Include 'esr001.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} ESR001
Monta impressão de relatório

@author Eloisa Anibaletto
@since 26/08/2022

/*/
//-------------------------------------------------------------------
User Function ESR001()

	Local oReport

	Private aCampo := {}

	oReport := U_ReportDef()
	oReport:SetPortrait()
	oReport:PrintDialog()

Return

User Function ReportDef()

	Local oCell
	Local oSection
	Local oReport := TReport():New(;
       "ESR001",;
        OEMTOANSI( STR0001 ),;//Relatório de Notas
        "ESR001",;
        { | oReport | U_ReportPrint( oReport ) },;
        STR0002;//Descrição do Relatório
    )

	oReport:ShowParamPage()
	oReport:lParamPage := .F.
	oReport:lHeaderVisible := .F.

	oSection := TRSection():New( oReport, "", "" )
	oSection2 := TRSection():New( oReport, "", "" )

	oCell := TRCell():New( oSection, STR0003 , NIL, NIL, NIL, 13, NIL, { || aCampo [ nPos, 01 ] } ) //Matrícula
	oCell := TRCell():New( oSection, STR0004 , NIL, NIL, NIL, 40, NIL, { || aCampo [ nPos, 02 ] } ) //Nome do Aluno
	oCell := TRCell():New( oSection, STR0005 , NIL, NIL, NIL, 08, NIL, { || aCampo [ nPos, 03 ] } ) //Cód. Turma
	oCell := TRCell():New( oSection, STR0006 , NIL, NIL, NIL, 30, NIL, { || aCampo [ nPos, 04 ] } ) //Descrição da Turma
	oCell := TRCell():New( oSection, STR0007 , NIL, NIL, NIL, 08, NIL, { || aCampo [ nPos, 05 ] } ) //Cód. Matéria
	oCell := TRCell():New( oSection, STR0008 , NIL, NIL, NIL, 25, NIL, { || aCampo [ nPos, 06 ] } ) //Descrição da Matéria
	oCell := TRCell():New( oSection, STR0009 , NIL, NIL, NIL, 22, NIL, { || aCampo [ nPos, 07 ] } ) //Nota
	oCell := TRCell():New( oSection, STR0010 , NIL, NIL, NIL, 10, NIL, { || aCampo [ nPos, 08 ] } ) //Data
	oCell := TRCell():New( oSection, STR0011 , NIL, NIL, NIL, 11, NIL, { || aCampo [ nPos, 09 ] } ) //Matrícula do Prof
	oCell := TRCell():New( oSection, STR0012 , NIL, NIL, NIL, 40, NIL, { || aCampo [ nPos, 10 ] } ) //Nome do Professor

	oCell := TRCell():New( oSection2, "", Nil, Nil, Nil, 40, Nil, { || STR0013 + CValToChar( ( Len( aAlunCount ) ) ) } ) //Total alunos
	oCell := TRCell():New( oSection2, "", NIL, NIL, NIL, 40, NIL, { || STR0014 + CValToChar( ( Len( aMateCount ) ) ) } ) //Total matérias
	oCell := TRCell():New( oSection2, "", NIL, NIL, NIL, 40, NIL, { || STR0015 + CValToChar( ( Len( aDiscCount ) ) ) } ) //Total disciplinas
	oCell := TRCell():New( oSection2, "", NIL, NIL, NIL, 40, NIL, { || STR0016 + CValToChar( ( Len( aTurmCount ) ) ) } ) //Total turmas
	oCell := TRCell():New( oSection2, "", NIL, NIL, NIL, 40, NIL, { || STR0017 + CValToChar( nNotaMaior ) } ) //Nota maior
	oCell := TRCell():New( oSection2, "", NIL, NIL, NIL, 40, NIL, { || STR0018 + CValToChar( nNotaMenor ) } ) //Nota menor

Return oReport

User Function ReportPrint( oReport )

	Local cAlias := GetNextAlias()
 
	Local ni := 0

	Local oSection := oReport:Section( 1 )
	Local oSection2 := oReport:Section( 2 )

	Private aAlunCount := {}
	Private aMateCount := {}
	Private aDiscCount := {}
	Private aTurmCount := {}
	Private nNotaMaior := 0
	Private nNotaMenor := 10

	Private nPos := 0

	If Mv_Par02 = ""
		Mv_Par02 := "zzzzzzzzz"
	EndIf
	If Mv_Par04 = ""
		Mv_Par04 := "zzzzz"
	EndIf
	If Mv_Par06 = ""
		Mv_Par06 := "zzzzzz"
	EndIf

	BeginSql Alias cAlias

		SELECT 
			ZZ2.ZZ2_MATAL, ZZ2.ZZ2_NOME, ZZ4.ZZ4_TURMA, ZZ4.ZZ4_DESCT, ZZ3.ZZ3_CODMAT,
			ZZ3.ZZ3_DESCRI, ZZ7.ZZ7_NOTA, ZZ7.ZZ7_DATA, ZZ1.ZZ1_MAT, ZZ1.ZZ1_NOME, ZZ6.ZZ6_DISC

		FROM
			%table:ZZ7% ZZ7

			INNER JOIN %table:ZZ6% ZZ6 ON
					ZZ7.ZZ7_DISC = ZZ6.ZZ6_DISC
					AND ZZ7.ZZ7_FILIAL = ZZ6.ZZ6_FILIAL
					AND ZZ6.%notDel%

			INNER JOIN %table:ZZ4% ZZ4 ON
					ZZ6.ZZ6_TURMA = ZZ4.ZZ4_TURMA
					AND ZZ6.ZZ6_FILIAL = ZZ4.ZZ4_FILIAL
					AND ZZ4.%notDel%

			INNER JOIN %table:ZZ3% ZZ3 ON 
					ZZ6.ZZ6_CODMAT = ZZ3.ZZ3_CODMAT 
					AND ZZ6.ZZ6_FILIAL = ZZ3.ZZ3_FILIAL
					AND ZZ3.%notDel%

			INNER JOIN %table:ZZ1% ZZ1 ON
				    ZZ6.ZZ6_MAT = ZZ1.ZZ1_MAT
					AND ZZ6.ZZ6_FILIAL = ZZ1.ZZ1_FILIAL
					AND ZZ1.%notDel%
					
			INNER JOIN %table:ZZ2% ZZ2 ON 
					ZZ7.ZZ7_MATAL = ZZ2.ZZ2_MATAL  
					AND ZZ7.ZZ7_FILIAL = ZZ2.ZZ2_FILIAL
					AND ZZ2.%notDel%

			
		WHERE   ZZ2.ZZ2_MATAL BETWEEN %Exp:Mv_Par01% And %Exp:Mv_Par02%
			AND ZZ6.ZZ6_DISC  BETWEEN %Exp:Mv_Par03% And %Exp:Mv_Par04%
			AND ZZ4.ZZ4_TURMA BETWEEN %Exp:Mv_Par05% And %Exp:Mv_Par06%

		GROUP BY
			ZZ2.ZZ2_MATAL, ZZ2.ZZ2_NOME, ZZ4.ZZ4_TURMA, ZZ4.ZZ4_DESCT, ZZ3.ZZ3_CODMAT,
			ZZ3.ZZ3_DESCRI, ZZ7.ZZ7_NOTA, ZZ7.ZZ7_DATA, ZZ1.ZZ1_MAT, ZZ1.ZZ1_NOME, ZZ6.ZZ6_DISC
		
		ORDER BY ZZ2.ZZ2_NOME

	EndSql

	( cAlias )->( DbGoTop() )

		aAdd( aCampo, {;
			( cAlias )->ZZ1_MAT,;
			( cAlias )->ZZ1_NOME,;
			( cAlias )->ZZ4_TURMA,;
			( cAlias )->ZZ4_DESCT,;
			( cAlias )->ZZ3_CODMAT,;
			( cAlias )->ZZ3_DESCRI,;
			( cAlias )->ZZ7_NOTA,;
			( cAlias )->ZZ7_DATA,;
			( cAlias )->ZZ2_MATAL,;
			( cAlias )->ZZ2_NOME;
		} )

		If aScan(aDiscCount, ( cAlias )->ZZ6_DISC) == 0
			Aadd(aDiscCount,( cAlias )->ZZ6_DISC)
		EndIf

		If aScan(aAlunCount, ( cAlias )->ZZ2_MATAL) == 0
			Aadd(aAlunCount,( cAlias )->ZZ2_MATAL)
		EndIf

		If aScan(aTurmCount, ( cAlias )->ZZ4_TURMA) == 0
			Aadd(aTurmCount,( cAlias )->ZZ4_TURMA)
		EndIf

		If aScan(aMateCount, ( cAlias )->ZZ3_CODMAT) == 0
			Aadd(aMateCount,( cAlias )->ZZ3_CODMAT)
		EndIf

		If ( cAlias )->ZZ7_NOTA > nNotaMaior
			nNotaMaior := ( cAlias )->ZZ7_NOTA
		EndIf
		
		If ( cAlias )->ZZ7_NOTA < nNotaMenor
			nNotaMenor := ( cAlias )->ZZ7_NOTA
		EndIf

		( cAlias )->( DbSkip() )

	( cAlias )->( DbCloseArea() )

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
