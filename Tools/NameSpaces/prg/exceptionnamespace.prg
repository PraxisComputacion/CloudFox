#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
Endif

* ExceptionNameSpace
Define Class ExceptionNameSpace As NamespaceBase Of 'Tools\namespaces\prg\ObjectNamespace.prg' 

	#If .F.
		Local This As ExceptionNameSpace Of 'Tools\namespaces\prg\ExceptionNameSpace.prg'
	#Endif

	Protected m._MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "parseerror" type = "method" display = "ParseError" />] ;
		+ [<memberdata name = "showerror" type = "method" display = "ShowError" />] ;
		+ [</VFPData>]

	Dimension ParseError_COMATTRIB[ 5 ]
	ParseError_COMATTRIB[ 1 ] = 0
	ParseError_COMATTRIB[ 2 ] = 'Devuelve una cadena con el mensaje de error formateado.'
	ParseError_COMATTRIB[ 3 ] = 'ParseError'
	ParseError_COMATTRIB[ 4 ] = 'String'
	* ParseError_COMATTRIB[ 5 ] = 0

	* ParseError
	* Devuelve una cadena con el mensaje de error formateado.
	Function ParseError ( toException As Exception ) As String HelpString 'Devuelve una cadena con el mensaje de error formateado.'

		Local lcField As String, ;
			lcStack As String, ;
			lcTable As String, ;
			liIdx As Integer, ;
			lnBegin As Integer, ;
			lnEnd As Integer, ;
			loError As Exception

		Assert Vartype( toException ) == 'O' Message 'ArgumentNullException( toException )'
		Assert Lower( toException.BaseClass ) == 'exception' Message 'InvalidDataTypeException( toException )'

		loError = toException
		Do While loError.ErrorNo = 2071 And Vartype ( loError.UserValue ) == 'O' && User Thrown Error
			loError = loError.UserValue

		Enddo

		Do Case

			Case Between ( loError.ErrorNo, 9990, 9999 )	 && Error generated by the user.
				lcRet = Alltrim ( loError.Message ) + CR ;
					+ Alltrim ( loError.Details )

			Case loError.ErrorNo = 1884	 && The uniqueness of primary or candidate key is violated.

				lcField = Alltrim ( loError.Details )
				lcRet = CR ;
					+ 'Ha intentado ingresar un valor ya existente' + CR ;
					+ 'en ' + Upper ( Right ( lcField, Len ( lcField ) ) ) + '.' + CR ;
					+ CR + 'Los datos no han sido guardados.'


			Case [Microsoft OLE DB Provider for SQL Server : Cannot insert duplicate key row in object] $ loError.Message ;
					And [with unique index] $ loError.Message

				lnBegin = Atc ( ['], loError.Details, 1 ) + 1
				lnEnd   = Atc ( ['], loError.Details, 2 )
				lcTable = Substr ( loError.Details, lnBegin, lnEnd - lnBegin )
				lcRet = CR ;
					+ 'Ha intentado ingresar un valor ya existente' + CR ;
					+ 'en la tabla ' + Upper ( lcTable ) + '.' + CR ;
					+ CR + 'Los datos no han sido guardados.'

			Case [Multiple - step operation generated error] $ loError.Message

				lcRet = CR ;
					+ [MULTIPLE-STEP OPERATION GENERATED ERROR] + CR + CR ;
					+ [This error means that one or more fields you are inserting/updating] + CR ;
					+ [contain an invalid value. Some of the possible scenarios are:] + CR + CR ;
					+ [1. A string value is being inserted into a numeric field.] + CR ;
					+ [2. An invalid date expression is being inserted into a date field.] + CR ;
					+ [3. A string value being inserted is longer than the size of the string field.] + CR ;
					+ [4. A null value is being inserted into a field that does not allow nulls.]

			Otherwise
				lcStack = []
				For liIdx = 1 To Program ( -1 ) - 1
					lcStack = lcStack + Proper ( Program ( liIdx ) ) + [; ]

				Next

				Aerror ( laError )

				*!*	lcRet = CR ;
				*!*		+ [Error:        ] + Alltrim ( Transform ( loError.ErrorNo ) ) + CR ;
				*!*		+ [Message:      ] + Alltrim ( loError.Message ) + CR ;
				*!*		+ [Procedure:    ] + Alltrim ( loError.Procedure ) + CR ;
				*!*		+ [LineNo:       ] + Alltrim ( Transform ( loError.Lineno ) ) + CR ;
				*!*		+ [Details:      ] + Alltrim ( loError.Details ) + CR ;
				*!*		+ [StackLevel:   ] + Alltrim ( Transform ( loError.StackLevel ) ) + CR ;
				*!*		+ [StackContent: ] + lcStack + CR ;
				*!*		+ [LineContents: ] + Alltrim ( loError.LineContents ) && + CR ;
				*!*		+ [UserValue:    ] + toException.UserValue

				TEXT To lcRet Noshow Textmerge Pretext 03
				[Error:        ] <<loError.ErrorNo>>
				[Mensaje:      ] <<loError.Message>>
				[Metodo:       ] <<loError.Procedure>>
				[Linea N�:     ] <<loError.Lineno>> | <<Lineno()>> | <<Lineno( 1 )>>
				[Comando:      ] <<loError.LineContents>>
				[Detalle:      ] <<loError.Details>>
				[StackLevel:   ] <<loError.StackLevel>>
				[StackContent: ] <<lcStack>>
				[AppName:      ] <<m.logical.IfEmpty( laError[ 1, 4 ], '' )>>
				[HelpFile:     ] <<m.logical.IfEmpty( laError[ 1, 5 ], '' )>>
				[HelpId:       ] <<m.logical.IfEmpty( laError[ 1, 6 ], '' )>>
				[OLEExcNo:     ] <<m.logical.IfEmpty( laError[ 1, 7 ], '' )>>
				[UserValue:    ] <<loError.UserValue>>
				ENDTEXT

		Endcase

		Return lcRet

	Endfunc && ParseError

	Dimension Process_COMATTRIB[ 5 ]
	Process_COMATTRIB[ 1 ] = 0
	Process_COMATTRIB[ 2 ] = 'Procesa una excepcion agregandole la informaci�n de contexto.'
	Process_COMATTRIB[ 3 ] = 'Process'
	Process_COMATTRIB[ 4 ] = 'Void'
	* Process_COMATTRIB[ 5 ] = 0

	* Process
	* Procesa una excepcion agregandole la informaci�n de contexto.
	Procedure Process ( toException As Exception @, taStackTrace As Variant @ ) As Void HelpString 'Procesa una excepcion agregandole la informaci�n de contexto.'
		If Vartype ( m.toException ) == 'O'

		Endif && Vartype ( m.toException ) == 'O'

	Endproc && Process

	Dimension ShowError_COMATTRIB[ 5 ]
	ShowError_COMATTRIB[ 1 ] = 0
	ShowError_COMATTRIB[ 2 ] = 'Muestra un mensaje de error formateado para la excepcion dada.'
	ShowError_COMATTRIB[ 3 ] = 'ShowError'
	ShowError_COMATTRIB[ 4 ] = 'Void'
	* ShowError_COMATTRIB[ 5 ] = 1

	* ShowError
	* Muestra un mensaje de error formateado para la excepcion dada.
	Procedure ShowError ( toException As Exception, tcRem As String, tcCaption As String ) As Void HelpString 'Muestra un mensaje de error formateado para la excepcion dada.'

		Local laError[1], ;
			lcText As String, ;
			loErr As Exception

		Try

			lcText = 'No se ha podido procesar el error .... '

			If Empty ( tcRem )
				tcRem = ''

			Endif && Empty( tcRem )

			If Empty ( tcCaption )
				tcCaption = 'Ha ocurrido un error'

			Endif && Empty( tcCaption )

			*!*	Aerror ( laError )

			*!*	If Vartype ( toException ) == 'O' And Lower ( toException.BaseClass ) == 'exception'
			*!*		Do While Vartype ( toException.UserValue ) == 'O'
			*!*			toException = toException.UserValue

			*!*		Enddo

			*!*		TEXT To lcText Noshow Textmerge Pretext 03
			*!*		<<tcRem>>
			*!*		[Metodo:   ] <<toException.Procedure>>
			*!*		[Linea N�: ] <<toException.Lineno>>
			*!*		[Comando:  ] <<toException.LineContents>>
			*!*		[Error:    ] <<toException.ErrorNo>>
			*!*		[Mensaje:  ] <<toException.Message>>
			*!*		[Detalle:  ] <<toException.Details>>
			*!*		[AppName:  ] <<m.logical.IfEmpty( laError[ 1, 4 ], '' )>>
			*!*		[HelpFile: ] <<m.logical.IfEmpty( laError[ 1, 5 ], '' )>>
			*!*		[HelpId:   ] <<m.logical.IfEmpty( laError[ 1, 6 ], '' )>>
			*!*		[OLEExcNo: ] <<m.logical.IfEmpty( laError[ 1, 7 ], '' )>>
			*!*		ENDTEXT

			*!*	Else && Vartype( toException ) == "O" And Lower( toException.BaseClass ) = "exception"

			*!*		tcRem = 'ADVERTENCIA: Se capturo la ultima excepci�n' + CR + tcRem

			*!*		TEXT To lcText Noshow Textmerge Pretext 03
			*!*		<<tcRem>>
			*!*		[Metodo:   ] <<Program( Program( -1 ) - 1 )>>
			*!*		[Linea N�: ] <<Lineno()>> | <<Lineno( 1 )>>
			*!*		[Error:    ] <<Transform( IfEmpty( laError[ 1, 1 ], 0  ))>>
			*!*		[Mensaje:  ] <<m.logical.IfEmpty( laError[ 1, 2 ], '' )>>
			*!*		[Detalle:  ] <<m.logical.IfEmpty( laError[ 1, 3 ], '' )>>
			*!*		[AppName:  ] <<m.logical.IfEmpty( laError[ 1, 4 ], '' )>>
			*!*		[HelpFile: ] <<m.logical.IfEmpty( laError[ 1, 5 ], '' )>>
			*!*		[HelpId:   ] <<m.logical.IfEmpty( laError[ 1, 6 ], '' )>>
			*!*		[OLEExcNo: ] <<m.logical.IfEmpty( laError[ 1, 7 ], '' )>>
			*!*		ENDTEXT

			*!*	Endif && Vartype( toException ) == "O" And Lower( toException.BaseClass ) = "exception"

			lcText = This.ParseError( toException )
			m.GUI.Stop ( lcText, tcCaption )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toException, tcRem, tcCaption
			THROW_EXCEPTION

		Endtry

	Endproc && ShowError

Enddefine && ExceptionNameSpace