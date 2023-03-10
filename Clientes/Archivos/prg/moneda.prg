#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Moneda( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loMoneda As oMoneda Of "Clientes\Archivos\prg\Moneda.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loMoneda = GetEntity( "Moneda" )
		loMoneda.Initialize( loParam )

		AddProperty( loParam, "oBiz", loMoneda )

		Do Form (loMoneda.cGrilla) ;
			With loParam To loReturn



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loMoneda = Null

	Endtry

Endproc && Moneda

*!* ///////////////////////////////////////////////////////
*!* Class.........: oMoneda
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oMoneda As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oMoneda Of "Clientes\Archivos\prg\Moneda.prg"
	#Endif

	lEditInBrowse 		= .F.
	lShowEditInBrowse 	= .F.
	cModelo 		= "Moneda"

	cFormIndividual = "Clientes\Archivos\Scx\Moneda.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Monedas.scx"

	cTituloEnForm 	= "Moneda"
	cTituloEnGrilla = "Monedas"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*
	* cUrl_Access
	Procedure cUrl_Access()

		If Empty( Alltrim( This.cURL ))
			* Inicializar la URL
			* Puede ponerse duro para cada modelo,
			* o leerse de un archivo de configuración local
			* para una personalización especial

			This.cURL = "sistema/apis/Moneda/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oMoneda
*!*
*!* ///////////////////////////////////////////////////////
