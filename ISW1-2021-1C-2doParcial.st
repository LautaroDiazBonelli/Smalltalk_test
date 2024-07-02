!classDefinition: #CartaDeTrucoTest category: #'ISW1-2021-1C-2doParcial'!
TestCase subclass: #CartaDeTrucoTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2021-1C-2doParcial'!

!CartaDeTrucoTest methodsFor: 'test - igualdad' stamp: 'HAW 7/4/2021 17:31:47'!
test01SonIgualesConMismoPaloYNumero

	self assert: (CartaDeTruco bastoCon: 1) = (CartaDeTruco bastoCon: 1) 

	! !

!CartaDeTrucoTest methodsFor: 'test - igualdad' stamp: 'HAW 7/4/2021 17:31:47'!
test02SonDistintasConDistintoPalo

	self deny: (CartaDeTruco bastoCon: 1) = (CartaDeTruco oroCon: 1) 

	! !

!CartaDeTrucoTest methodsFor: 'test - igualdad' stamp: 'HAW 7/4/2021 17:31:47'!
test03SonDistintasConNumeroAunqueIgualPalo

	self deny: (CartaDeTruco bastoCon: 1) = (CartaDeTruco bastoCon: 2) 

	! !

!CartaDeTrucoTest methodsFor: 'test - igualdad' stamp: 'HAW 7/4/2021 17:31:47'!
test04CartasIgualesTienenElMismoHash

	self assert: (CartaDeTruco bastoCon: 1) hash equals: (CartaDeTruco bastoCon: 1) hash

	! !

!CartaDeTrucoTest methodsFor: 'test - igualdad' stamp: 'HAW 7/4/2021 17:31:47'!
test05UnaCartaEsDistintaACualquierObjetoQueNoSeaCarta

	self deny: (CartaDeTruco bastoCon: 1) = 1! !


!CartaDeTrucoTest methodsFor: 'test - creacion' stamp: 'HAW 7/5/2021 11:58:02'!
test07NoHayCartaDeTrucoConNumeroOcho

	self 
		should: [ CartaDeTruco oroCon: 8 ]
		raise: Error
		withMessageText: CartaDeTruco numeroDeCartaInvalidoErrorDescription! !

!CartaDeTrucoTest methodsFor: 'test - creacion' stamp: 'HAW 7/5/2021 11:58:02'!
test08NoHayCartaDeTrucoConNumeroNueve

	self 
		should: [ CartaDeTruco oroCon: 9 ]
		raise: Error
		withMessageText: CartaDeTruco numeroDeCartaInvalidoErrorDescription! !

!CartaDeTrucoTest methodsFor: 'test - creacion' stamp: 'HAW 7/5/2021 11:58:12'!
test09LosPalosDeLaCartaDeTrucoSonBastoOroEspadaYCopa

	self 
		should: [ CartaDeTruco palo: #otro numero: 1 ]
		raise: Error
		withMessageText: CartaDeTruco paloInvalidoErrorDescription! !

!CartaDeTrucoTest methodsFor: 'test - creacion' stamp: 'HAW 7/5/2021 11:58:02'!
test10NoSePuedeCrearCartaConNumeroMenorAUno

	self 
		should: [ CartaDeTruco espadaCon: 0 ]
		raise: Error 
		withMessageText: CartaDeTruco numeroDeCartaInvalidoErrorDescription ! !

!CartaDeTrucoTest methodsFor: 'test - creacion' stamp: 'HAW 7/5/2021 11:58:02'!
test11NoSePuedeCrearCartaConNumeroMayorADoce

	self 
		should: [ CartaDeTruco espadaCon: 13 ]
		raise: Error 
		withMessageText: CartaDeTruco numeroDeCartaInvalidoErrorDescription ! !

!CartaDeTrucoTest methodsFor: 'test - creacion' stamp: 'HAW 7/5/2021 11:58:02'!
test12ElNumeroDeLaCartaDebeSerEntero

	self 
		should: [ CartaDeTruco espadaCon: 1.1 ]
		raise: Error 
		withMessageText: CartaDeTruco numeroDeCartaInvalidoErrorDescription ! !


!CartaDeTrucoTest methodsFor: 'test - enfrentamiento' stamp: 'LD 7/1/2024 20:38:37'!
jugadorBasto
	^ (JugadorDeTruco new) carta1: (CartaDeTruco bastoCon: 1) 
		carta2: (CartaDeTruco bastoCon: 4)
		carta3: (CartaDeTruco bastoCon: 7).! !

!CartaDeTrucoTest methodsFor: 'test - enfrentamiento' stamp: 'LD 7/1/2024 20:44:15'!
jugadorCuatros
	^ (JugadorDeTruco new) carta1: (CartaDeTruco espadaCon: 4)		
		 carta2: (CartaDeTruco bastoCon: 4)
		 carta3: (CartaDeTruco oroCon: 4).! !

!CartaDeTrucoTest methodsFor: 'test - enfrentamiento' stamp: 'LD 7/1/2024 20:38:11'!
jugadorEspada
	^ (JugadorDeTruco new) carta1: (CartaDeTruco espadaCon: 1)		
		 carta2: (CartaDeTruco espadaCon: 4)
		 carta3: (CartaDeTruco espadaCon: 7).! !

!CartaDeTrucoTest methodsFor: 'test - enfrentamiento' stamp: 'LD 7/1/2024 20:40:02'!
test21TresEnfrentamientos
	| jugador1 jugador2 ronda |
	
	jugador1 := self jugadorEspada .
	jugador2 := self jugadorBasto .

	ronda := RondaDeTruco mano: jugador1 pie: jugador2.
	self assert: jugador1 equals: (ronda enfrentamientoJugador1: (jugador1 carta1) jugador2: (jugador2 carta2)) ganador.
	self assert: jugador1 equals: (ronda primerEnfrentamiento) ganador.

	
	self assert: jugador2 equals: (ronda enfrentamientoJugador1: (jugador1 carta2) jugador2: (jugador2 carta1)) ganador.
	self assert: jugador2 equals: (ronda segundoEnfrentamiento) ganador.

	self assert: jugador1 equals: (ronda enfrentamientoJugador1: (jugador1 carta3) jugador2: (jugador2 carta3)) ganador.
	self assert: jugador1 equals: (ronda tercerEnfrentamiento) ganador.
	
	
	self assert: jugador1 equals: (ronda ganador).
	! !

!CartaDeTrucoTest methodsFor: 'test - enfrentamiento' stamp: 'LD 7/1/2024 20:48:21'!
test22
	| jugador1 jugador2 ronda |
	
	jugador1 := self jugadorEspada.
	jugador2 := self jugadorCuatros .

	ronda := RondaDeTruco mano: jugador1 pie: jugador2.
	self assert: jugador1 equals: (ronda enfrentamientoJugador1: (jugador1 carta1) jugador2: (jugador2 carta2)) ganador.
	self assert: jugador1 equals: (ronda primerEnfrentamiento) ganador.

	
	self assert: jugador1 equals: (ronda enfrentamientoJugador1: (jugador1 carta3) jugador2: (jugador2 carta1)) ganador.
	self assert: jugador1 equals: (ronda segundoEnfrentamiento) ganador.
	
	self assert: jugador1 equals: (ronda ganador).
	
	'self should error enfrentamiento3'
	! !

!CartaDeTrucoTest methodsFor: 'test - enfrentamiento' stamp: 'LD 7/1/2024 21:14:38'!
test23
	|ronda |

	ronda := RondaDeTruco new.
	
	ronda jugador1JuegaCarta: (CartaDeTruco anchoDeEspada).
	ronda jugador2JuegaCarta: (CartaDeTruco copaCon: 4).
	self assert: (ronda enfrentar) ganador = #mano.
	
	ronda jugador1JuegaCarta: (CartaDeTruco oroCon: 4).
	ronda jugador2JuegaCarta: (CartaDeTruco anchoDeBasto).
	self assert: (ronda enfrentar) ganador = #mano.

	
	ronda jugador1JuegaCarta: (CartaDeTruco sieteDeEspada ).
	ronda jugador2JuegaCarta: (CartaDeTruco espadaCon: 4).
	self assert: (ronda enfrentar) ganador = #mano.

	
	self assert: ronda ganadorEsJugador1.
	
	! !


!CartaDeTrucoTest methodsFor: 'test - valor y comparacion' stamp: 'HAW 7/5/2021 10:55:30'!
test13LaTablaDeValoresEsCorrecta

	self assert: (CartaDeTruco anchoDeEspada mataA: CartaDeTruco anchoDeBasto).
	self assert: (CartaDeTruco anchoDeBasto mataA: CartaDeTruco sieteDeEspada).
	self assert: (CartaDeTruco sieteDeEspada mataA: CartaDeTruco sieteDeOro).
	self assert: (CartaDeTruco sieteDeOro mataA: (CartaDeTruco espadaCon: 3)).
	self assert: ((CartaDeTruco espadaCon: 3) empardaCon: (CartaDeTruco oroCon: 3)).
	self assert: ((CartaDeTruco espadaCon: 3) mataA: (CartaDeTruco espadaCon: 2)).
	self assert: ((CartaDeTruco espadaCon: 2) empardaCon: (CartaDeTruco oroCon: 2)).
	self assert: ((CartaDeTruco espadaCon: 2) mataA: (CartaDeTruco oroCon: 1)).
	self assert: ((CartaDeTruco oroCon: 1) empardaCon: (CartaDeTruco copaCon: 1)).
	self assert: ((CartaDeTruco oroCon: 1) mataA: (CartaDeTruco espadaCon: 12)).
	self assert: ((CartaDeTruco espadaCon: 12) empardaCon: (CartaDeTruco oroCon: 12)).
	self assert: ((CartaDeTruco espadaCon: 12) mataA: (CartaDeTruco espadaCon: 11)).
	self assert: ((CartaDeTruco espadaCon: 11) empardaCon: (CartaDeTruco oroCon: 11)).
	self assert: ((CartaDeTruco espadaCon: 11) mataA: (CartaDeTruco espadaCon: 10)).
	self assert: ((CartaDeTruco espadaCon: 10) empardaCon: (CartaDeTruco oroCon: 10)).
	self assert: ((CartaDeTruco espadaCon: 10) mataA: (CartaDeTruco copaCon: 7)).
	self assert: ((CartaDeTruco copaCon: 7) empardaCon: (CartaDeTruco bastoCon: 7)).
	self assert: ((CartaDeTruco copaCon: 7) mataA: (CartaDeTruco espadaCon: 6)).
	self assert: ((CartaDeTruco espadaCon: 6) empardaCon: (CartaDeTruco oroCon: 6)).
	self assert: ((CartaDeTruco espadaCon: 6) mataA: (CartaDeTruco espadaCon: 5)).
	self assert: ((CartaDeTruco espadaCon: 5) empardaCon: (CartaDeTruco oroCon: 5)).
	self assert: ((CartaDeTruco espadaCon: 5) mataA: (CartaDeTruco espadaCon: 4)).
	self assert: ((CartaDeTruco espadaCon: 4) empardaCon: (CartaDeTruco oroCon: 4)).

	{ 3. 2. 12. 11. 10. 6. 5. 4 } do: [ :unNumero |
		CartaDeTruco palos do: [ :unPalo | 
			self assert: ((CartaDeTruco espadaCon: unNumero) empardaCon: (CartaDeTruco palo: unPalo numero: unNumero)) ]]
	! !

!CartaDeTrucoTest methodsFor: 'test - valor y comparacion' stamp: 'HAW 7/5/2021 10:49:51'!
test14HayCartasQueNoSonPardas

	self deny: (CartaDeTruco anchoDeEspada empardaCon: CartaDeTruco anchoDeBasto)! !

!CartaDeTrucoTest methodsFor: 'test - valor y comparacion' stamp: 'HAW 7/5/2021 10:49:59'!
test15HayCartasQuePierdenConOtras

	self deny: (CartaDeTruco anchoDeBasto mataA: CartaDeTruco anchoDeEspada)! !

!CartaDeTrucoTest methodsFor: 'test - valor y comparacion' stamp: 'HAW 7/4/2021 17:53:21'!
test16SieteDeCopasYDeBastoEsSieteFalso

	self assert: (CartaDeTruco copaCon: 7) esSieteFalso.
	self assert: (CartaDeTruco bastoCon: 7) esSieteFalso ! !

!CartaDeTrucoTest methodsFor: 'test - valor y comparacion' stamp: 'HAW 7/4/2021 17:54:57'!
test17SieteDeOroYDeEspadaNoSonSieteFalso

	self deny: (CartaDeTruco sieteDeOro) esSieteFalso.
	self deny: (CartaDeTruco sieteDeEspada) esSieteFalso ! !

!CartaDeTrucoTest methodsFor: 'test - valor y comparacion' stamp: 'HAW 7/4/2021 17:55:53'!
test18AnchoDeOroYDeCopaSonAnchoFalsos

	self assert: (CartaDeTruco oroCon: 1) esAnchoFalso.
	self assert: (CartaDeTruco copaCon: 1) esAnchoFalso ! !

!CartaDeTrucoTest methodsFor: 'test - valor y comparacion' stamp: 'HAW 7/4/2021 17:56:28'!
test19AnchoDeEspadaYDeBastosNoSonAnchoFalsos

	self deny: (CartaDeTruco anchoDeEspada) esAnchoFalso.
	self deny: (CartaDeTruco anchoDeBasto) esAnchoFalso ! !

!CartaDeTrucoTest methodsFor: 'test - valor y comparacion' stamp: 'HAW 7/5/2021 11:58:24'!
test20FallaBuscandoValorDeCartaInválida

	"Creo una carta de manera inválida para probar la correctitud del la tabla de valores - Hernan"
	self 
		should: [ CartaDeTruco new initializePalo: #invalido numero: 1; valor ]
		raise: Error 
		withMessageText: CartaDeTruco tablaDeValoresIncorrectaOCartaInvalidaErrorDescription! !


!classDefinition: #CartaDeTruco category: #'ISW1-2021-1C-2doParcial'!
Object subclass: #CartaDeTruco
	instanceVariableNames: 'palo numero'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2021-1C-2doParcial'!

!CartaDeTruco methodsFor: 'initialization' stamp: 'HAW 7/3/2021 15:27:51'!
initializePalo: unPalo numero: unNumero 
	
	palo := unPalo.
	numero := unNumero.! !


!CartaDeTruco methodsFor: 'comparing' stamp: 'HAW 7/2/2021 11:44:36'!
= unaCarta 
	
	^(unaCarta isKindOf: self class) and: [(unaCarta paloEs: palo) and: [ unaCarta numeroEs: numero ]]! !

!CartaDeTruco methodsFor: 'comparing' stamp: 'HAW 7/5/2021 10:49:51'!
empardaCon: cartaParda

	^self valor = cartaParda valor! !

!CartaDeTruco methodsFor: 'comparing' stamp: 'HAW 7/2/2021 11:43:24'!
hash
	
	^palo hash bitXor: numero hash ! !

!CartaDeTruco methodsFor: 'comparing' stamp: 'HAW 7/5/2021 10:49:59'!
mataA: cartaPerdedora

	^self valor < cartaPerdedora valor! !

!CartaDeTruco methodsFor: 'comparing' stamp: 'HAW 7/2/2021 11:41:53'!
numeroEs: unNumero

	^numero = unNumero ! !

!CartaDeTruco methodsFor: 'comparing' stamp: 'HAW 7/2/2021 11:41:39'!
paloEs: unPalo

	^palo = unPalo ! !


!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/4/2021 17:50:20'!
esAncho

	^ self numeroEs: 1! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/4/2021 17:50:31'!
esAnchoDeBasto
	
	^self esAncho and: [ self esDeBasto ]! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/4/2021 17:50:41'!
esAnchoDeEspada
	
	^self esAncho and: [ self esDeEspada ]! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/4/2021 17:50:20'!
esAnchoFalso
	
	^self esAncho and: [ self esDeOro or: [ self esDeCopa ]]! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/3/2021 15:19:32'!
esCaballo
	
	^self numeroEs: 11! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/3/2021 15:25:29'!
esDeBasto
	
	^self paloEs: self basto! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/3/2021 15:26:09'!
esDeCopa
	
	^self paloEs: self copa! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/3/2021 15:26:18'!
esDeEspada
	
	^self paloEs: self espada ! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/3/2021 15:26:35'!
esDeOro
	
	^self paloEs: self oro! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/3/2021 15:19:22'!
esRey
	
	^self numeroEs: 12! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/3/2021 15:16:57'!
esSiete
	
	^self numeroEs: 7! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/3/2021 15:27:00'!
esSieteDeEspadas
	
	^self esSiete and: [ self esDeEspada ]! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/3/2021 15:27:15'!
esSieteDeOro
	
	^self esSiete and: [ self esDeOro ]! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/3/2021 15:26:09'!
esSieteFalso
	
	^self esSiete and: [ self esDeCopa or: [ self esDeBasto ]]! !

!CartaDeTruco methodsFor: 'testing' stamp: 'HAW 7/3/2021 15:19:43'!
esSota
	
	^self numeroEs: 10! !


!CartaDeTruco methodsFor: 'printing' stamp: 'HAW 7/3/2021 15:14:43'!
printOn: aStream

	aStream 
		print: numero;
		nextPutAll: ' de ';
		nextPutAll: 	palo ! !


!CartaDeTruco methodsFor: 'valor' stamp: 'HAW 7/3/2021 14:51:09'!
valor
	
	^self class valorDe: self! !


!CartaDeTruco methodsFor: 'palos' stamp: 'HAW 7/3/2021 15:24:33'!
basto
	
	^self class basto! !

!CartaDeTruco methodsFor: 'palos' stamp: 'HAW 7/3/2021 15:24:44'!
copa

	^ self class copa! !

!CartaDeTruco methodsFor: 'palos' stamp: 'HAW 7/3/2021 15:24:08'!
espada
	
	^self class espada! !

!CartaDeTruco methodsFor: 'palos' stamp: 'HAW 7/3/2021 15:26:27'!
oro

	^ self class oro! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartaDeTruco class' category: #'ISW1-2021-1C-2doParcial'!
CartaDeTruco class
	instanceVariableNames: 'ordenDePrioridad'!

!CartaDeTruco class methodsFor: 'instance creation' stamp: 'HAW 7/4/2021 17:49:37'!
anchoDeBasto
	
	^self bastoCon: 1! !

!CartaDeTruco class methodsFor: 'instance creation' stamp: 'HAW 7/4/2021 17:49:57'!
anchoDeEspada
	
	^self espadaCon: 1! !

!CartaDeTruco class methodsFor: 'instance creation' stamp: 'HAW 7/3/2021 14:57:03'!
bastoCon: unNumero

	^self palo: self basto numero: unNumero! !

!CartaDeTruco class methodsFor: 'instance creation' stamp: 'HAW 7/3/2021 14:57:08'!
copaCon: unNumero

	^self palo: self copa numero: unNumero! !

!CartaDeTruco class methodsFor: 'instance creation' stamp: 'HAW 7/3/2021 14:57:16'!
espadaCon: unNumero

	^self palo: self espada numero: unNumero ! !

!CartaDeTruco class methodsFor: 'instance creation' stamp: 'HAW 7/3/2021 14:57:34'!
oroCon: unNumero

	^self palo: self oro numero: unNumero ! !

!CartaDeTruco class methodsFor: 'instance creation' stamp: 'HAW 7/4/2021 18:06:08'!
palo: unPalo numero: unNumero 
	
	self assertNúmeroEsVálido: unNumero.
	self assertPaloEsVálido: unPalo.
	
	^self new initializePalo: unPalo numero: unNumero ! !

!CartaDeTruco class methodsFor: 'instance creation' stamp: 'HAW 7/3/2021 15:12:50'!
sieteDeEspada
	
	^self espadaCon: 7! !

!CartaDeTruco class methodsFor: 'instance creation' stamp: 'HAW 7/3/2021 15:17:44'!
sieteDeOro
	
	^self oroCon: 7! !


!CartaDeTruco class methodsFor: 'palos' stamp: 'HAW 7/3/2021 14:56:25'!
basto
	
	^#basto! !

!CartaDeTruco class methodsFor: 'palos' stamp: 'HAW 7/3/2021 14:57:25'!
copa
	
	^#copa! !

!CartaDeTruco class methodsFor: 'palos' stamp: 'HAW 7/3/2021 14:55:44'!
espada
	
	^#espada! !

!CartaDeTruco class methodsFor: 'palos' stamp: 'HAW 7/3/2021 14:57:43'!
oro
	
	^#oro! !

!CartaDeTruco class methodsFor: 'palos' stamp: 'HAW 7/4/2021 18:07:36'!
palos

	"No se puede acceder a self en backtick, por eso se usa CartaDeTruco como receiver - Hernan"
	^ `{CartaDeTruco espada. CartaDeTruco basto. CartaDeTruco oro. CartaDeTruco copa }`! !


!CartaDeTruco class methodsFor: 'initialization' stamp: 'HAW 7/5/2021 10:52:07'!
initializeOrdenDePrioridad
	
	"Cuanto más chico sea el índice de la carta en esta colección, más valor tiene - Hernan"
	ordenDePrioridad := OrderedCollection new.
	
	ordenDePrioridad 
		add: [ :carta | carta esAnchoDeEspada ];
		add: [ :carta | carta esAnchoDeBasto ];
		add: [ :carta | carta esSieteDeEspadas ];
		add: [ :carta | carta esSieteDeOro ];
		add: [ :carta | carta numeroEs: 3 ];
		add: [ :carta | carta numeroEs: 2 ];
		add: [ :carta | carta esAnchoFalso ];
		add: [ :carta | carta esRey ];
		add: [ :carta | carta esCaballo ];
		add: [ :carta | carta esSota ];
		add: [ :carta | carta esSieteFalso ];
		add: [ :carta | carta numeroEs: 6 ];
		add: [ :carta | carta numeroEs: 5 ];
		add: [ :carta | carta numeroEs: 4 ];
		yourself.
	
	! !


!CartaDeTruco class methodsFor: 'valor' stamp: 'HAW 7/3/2021 14:54:01'!
ordenDePrioridad
	
	^ordenDePrioridad ifNil: [ self initializeOrdenDePrioridad ] ! !

!CartaDeTruco class methodsFor: 'valor' stamp: 'HAW 7/5/2021 11:58:24'!
valorDe: unaCarta 
	
	self ordenDePrioridad withIndexDo: [ :bloqueDeVerificacion :index |
		(bloqueDeVerificacion value: unaCarta) ifTrue: [ ^index ]].
	
	self error: self tablaDeValoresIncorrectaOCartaInvalidaErrorDescription! !


!CartaDeTruco class methodsFor: 'error descriptions' stamp: 'HAW 7/5/2021 11:58:02'!
numeroDeCartaInvalidoErrorDescription
	
	^'El truco no se puede jugar con ochos ni con nueves'! !

!CartaDeTruco class methodsFor: 'error descriptions' stamp: 'HAW 7/5/2021 11:58:12'!
paloInvalidoErrorDescription
	
	^'Los palos de la carta solo pueden ser espada, basto, oro y copa'! !

!CartaDeTruco class methodsFor: 'error descriptions' stamp: 'HAW 7/5/2021 11:58:24'!
tablaDeValoresIncorrectaOCartaInvalidaErrorDescription
	
	^'Error de programación: Tabla de valores incorrecta o carta inválida'! !


!CartaDeTruco class methodsFor: 'assertions' stamp: 'HAW 7/5/2021 11:58:02'!
assertNúmeroEsVálido: unNumero

	unNumero < 1 ifTrue: [ self error: self numeroDeCartaInvalidoErrorDescription ].
	unNumero > 12 ifTrue: [ self error: self numeroDeCartaInvalidoErrorDescription ].
	(unNumero between: 8 and: 9) ifTrue: [ self error: self numeroDeCartaInvalidoErrorDescription ].
	unNumero isInteger ifFalse: [ self error: self numeroDeCartaInvalidoErrorDescription ]! !

!CartaDeTruco class methodsFor: 'assertions' stamp: 'HAW 7/5/2021 11:58:12'!
assertPaloEsVálido: unPalo

	^ (self palos includes: unPalo) ifFalse: [ self error: self paloInvalidoErrorDescription ]! !


!classDefinition: #EnfrentamientoTruco category: #'ISW1-2021-1C-2doParcial'!
Object subclass: #EnfrentamientoTruco
	instanceVariableNames: 'cartaJugador1 cartaJugador2 ganador jugador1 jugador2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2021-1C-2doParcial'!

!EnfrentamientoTruco methodsFor: 'initialization' stamp: 'LD 7/1/2024 20:09:05'!
initializeJugador1: unJugador1 juega: unaCartaJugador1 jugador2: unJugador2 juega: unaCartaJugador2 
	cartaJugador1 := unaCartaJugador1.
	cartaJugador2 := unaCartaJugador2.
	jugador1 :=unJugador1.
	jugador2 :=unJugador2.

	
	
	self enfrentar.! !


!EnfrentamientoTruco methodsFor: 'evaluating' stamp: 'LD 7/1/2024 21:01:21'!
enfrentar
	(cartaJugador1 mataA: cartaJugador2)	 ifTrue: [ganador := jugador1.] .
	(cartaJugador2 mataA: cartaJugador1)	 ifTrue:  [ganador := jugador2 ] 	.
	
	(cartaJugador1 empardaCon: cartaJugador2) ifTrue: [ ganador := nil].
	
	

! !

!EnfrentamientoTruco methodsFor: 'evaluating' stamp: 'LD 7/1/2024 20:56:09'!
esEmpate
	^ ganador = nil! !

!EnfrentamientoTruco methodsFor: 'evaluating' stamp: 'LD 7/1/2024 20:03:36'!
ganador
	^ganador ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EnfrentamientoTruco class' category: #'ISW1-2021-1C-2doParcial'!
EnfrentamientoTruco class
	instanceVariableNames: ''!

!EnfrentamientoTruco class methodsFor: 'instance creation' stamp: 'LD 7/1/2024 20:12:06'!
jugador1: unJugador1 juega: unaCarta1 jugador2: unJugador2 juega: unaCarta2
	^self new initializeJugador1: unJugador1 juega: unaCarta1 jugador2: unJugador2 juega: unaCarta2 
! !


!classDefinition: #JugadorDeTruco category: #'ISW1-2021-1C-2doParcial'!
Object subclass: #JugadorDeTruco
	instanceVariableNames: 'carta1 carta2 carta3'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2021-1C-2doParcial'!

!JugadorDeTruco methodsFor: 'evaluating' stamp: 'LD 7/1/2024 19:36:53'!
carta1: aCarta1 carta2: aCarta2 carta3: aCarta3 
	carta1 :=aCarta1.
	carta2 :=aCarta2.
	carta3 :=aCarta3.! !


!JugadorDeTruco methodsFor: 'accesing' stamp: 'LD 7/1/2024 19:57:11'!
carta1
	^carta1! !

!JugadorDeTruco methodsFor: 'accesing' stamp: 'LD 7/1/2024 19:57:28'!
carta2
	^carta2! !

!JugadorDeTruco methodsFor: 'accesing' stamp: 'LD 7/1/2024 20:32:00'!
carta3
	^carta3! !


!classDefinition: #RondaDeTruco category: #'ISW1-2021-1C-2doParcial'!
Object subclass: #RondaDeTruco
	instanceVariableNames: 'jugador1 jugador2 mano enfrentamientos'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2021-1C-2doParcial'!

!RondaDeTruco methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 20:31:50'!
addEnfrentamiento: anEnfrentamiento
	"hacer chekeos si es valido"
	enfrentamientos add: anEnfrentamiento.! !

!RondaDeTruco methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 20:20:37'!
enfrentamientoJugador1: unaCartaJugador1 jugador2: unaCartaJugador2 
	|enfrentamiento|
	enfrentamiento := EnfrentamientoTruco jugador1: jugador1 juega: unaCartaJugador1 
											jugador2: jugador2 juega: unaCartaJugador2 .
	
	self addEnfrentamiento: enfrentamiento.
	
	^enfrentamiento.! !

!RondaDeTruco methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 20:56:31'!
ganador
	(enfrentamientos size = 3) ifTrue: [^(enfrentamientos at:3) ganador].
	(enfrentamientos size = 2 and: [(enfrentamientos at:1) ganador = (enfrentamientos at:2) ganador]) 
			ifTrue: [^(enfrentamientos at:2) ganador].
	(enfrentamientos size = 2 and: [(enfrentamientos at:1) esEmpate]) 
			ifTrue: [^(enfrentamientos at:2) ganador].
	
	^self error: 'aun no hay ganador'.! !

!RondaDeTruco methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 20:20:46'!
initializeConMano: unaMano pie: unPie.
	jugador1 := unaMano.
	jugador2 := unPie.
	mano := jugador1.
	enfrentamientos := OrderedCollection new.! !

!RondaDeTruco methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 20:35:04'!
primerEnfrentamiento
	^enfrentamientos at:1.! !

!RondaDeTruco methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 20:35:23'!
segundoEnfrentamiento
	^enfrentamientos at:2.! !

!RondaDeTruco methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 20:35:41'!
tercerEnfrentamiento
	^ enfrentamientos at:3.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RondaDeTruco class' category: #'ISW1-2021-1C-2doParcial'!
RondaDeTruco class
	instanceVariableNames: ''!

!RondaDeTruco class methodsFor: 'initialization' stamp: 'LD 7/1/2024 19:41:18'!
mano: unaMano pie: unPie 
	^(self new) initializeConMano: unaMano pie: unPie.! !


!classDefinition: #RondaDeTruco2 category: #'ISW1-2021-1C-2doParcial'!
Object subclass: #RondaDeTruco2
	instanceVariableNames: 'jugador1 jugador2 mano enfrentamientos'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ISW1-2021-1C-2doParcial'!

!RondaDeTruco2 methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 21:04:59'!
addEnfrentamiento: anEnfrentamiento
	"hacer chekeos si es valido"
	enfrentamientos add: anEnfrentamiento.! !

!RondaDeTruco2 methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 21:04:59'!
enfrentamientoJugador1: unaCartaJugador1 jugador2: unaCartaJugador2 
	|enfrentamiento|
	enfrentamiento := EnfrentamientoTruco jugador1: jugador1 juega: unaCartaJugador1 
											jugador2: jugador2 juega: unaCartaJugador2 .
	
	self addEnfrentamiento: enfrentamiento.
	
	^enfrentamiento.! !

!RondaDeTruco2 methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 21:04:59'!
ganador
	(enfrentamientos size = 3) ifTrue: [^(enfrentamientos at:3) ganador].
	(enfrentamientos size = 2 and: [(enfrentamientos at:1) ganador = (enfrentamientos at:2) ganador]) 
			ifTrue: [^(enfrentamientos at:2) ganador].
	(enfrentamientos size = 2 and: [(enfrentamientos at:1) esEmpate]) 
			ifTrue: [^(enfrentamientos at:2) ganador].
	
	^self error: 'aun no hay ganador'.! !

!RondaDeTruco2 methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 21:04:59'!
initializeConMano: unaMano pie: unPie.
	jugador1 := unaMano.
	jugador2 := unPie.
	mano := jugador1.
	enfrentamientos := OrderedCollection new.! !

!RondaDeTruco2 methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 21:04:59'!
primerEnfrentamiento
	^enfrentamientos at:1.! !

!RondaDeTruco2 methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 21:04:59'!
segundoEnfrentamiento
	^enfrentamientos at:2.! !

!RondaDeTruco2 methodsFor: 'as yet unclassified' stamp: 'LD 7/1/2024 21:04:59'!
tercerEnfrentamiento
	^ enfrentamientos at:3.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RondaDeTruco2 class' category: #'ISW1-2021-1C-2doParcial'!
RondaDeTruco2 class
	instanceVariableNames: ''!

!RondaDeTruco2 class methodsFor: 'initialization' stamp: 'LD 7/1/2024 21:04:59'!
mano: unaMano pie: unPie 
	^(self new) initializeConMano: unaMano pie: unPie.! !
