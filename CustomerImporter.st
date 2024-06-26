!classDefinition: #PersistentSet category: #CustomerImporter!
Set subclass: #PersistentSet
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentSet methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:25:31'!
initializeOn: aSession from: aNonPersistentSet

	session := aSession.
	self addAll: aNonPersistentSet ! !


!PersistentSet methodsFor: 'adding' stamp: 'LD 6/27/2024 20:30:02'!
addCustomer: newObject

	super addCustomer: newObject.
	session persist: newObject.
	
	^newObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PersistentSet class' category: #CustomerImporter!
PersistentSet class
	instanceVariableNames: ''!

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:24:32'!
on: aSession

	^self on: aSession from: #()! !

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:25:00'!
on: aSession from: aNonPersistentSet

	^self new initializeOn: aSession from: aNonPersistentSet
! !


!classDefinition: #ImportTest category: #CustomerImporter!
TestCase subclass: #ImportTest
	instanceVariableNames: 'system'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 21:15:52'!
test01ValidDataIsImportedCorrectly

	CustomerImporter valueFrom: self validImportData into: system..

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 21:15:52'!
test02CanNotImportAddressWithoutCustomer

	self
		should: [ CustomerImporter valueFrom: self addressWithoutCustomerData into: system. ]
		raise: Error - MessageNotUnderstood
		withMessageText: CustomerImporter canNotImportAddressWithoutCustomerErrorDescription

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test03DoesNotImportRecordsStartingWithCButMoreCharacters

	self
		shouldFailImporting: self invalidCustomerRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:49:03'!
test04DoesNotImportRecordsStartingWithAButMoreCharacters

	self
		shouldFailImporting: self invalidAddressRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:49:36'!
test05CanNotImportAddressRecordWithLessThanSixFields

	self
		shouldFailImporting: self addressRecordWithLessThanSixFields
		messageText: CustomerImporter invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:51:14'!
test06CanNotImportAddressRecordWithMoreThanSixFields

	self
		shouldFailImporting: self addressRecordWithMoreThanSixFields
		messageText: CustomerImporter invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test07CanNotImportCustomerRecordWithLessThanFiveFields

	self
		shouldFailImporting: self customerRecordWithLessThanFiveFields
		messageText: CustomerImporter invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test08CanNotImportCustomerRecordWithMoreThanFiveFields

	self
		shouldFailImporting: self customerRecordWithMoreThanFiveFields
		messageText: CustomerImporter invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 20:01:43'!
test09CannotImportEmptyLine

	self
		shouldFailImporting: self emptyLine
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !


!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:22:05'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:34:30'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := system customerWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:34:37'!
assertImportedOneCustomerWithoutAddress

	| importedCustomer |

	self assert: 1 equals: system numberOfCustomers.
	importedCustomer := system customerWithIdentificationType: 'D' number: '22333444'.
	self assert: importedCustomer isAddressesEmpty
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:33:18'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: system numberOfCustomers! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:33:24'!
assertNoCustomerWasImported

	^ self assert: 0 equals: system numberOfCustomers! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:15:52'!
shouldFailImporting: aReadStream messageText: anErrorMessageText asserting: anAssertionBlock

	self
		should: [ CustomerImporter valueFrom: aReadStream into: system. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anErrorMessageText equals: anError messageText.
			anAssertionBlock value ]

	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'LD 6/27/2024 20:06:03'!
setUp

	"system := Environment current createCustomerSystem."
	system := DevelopmentEnvironment new createCustomerSystem.
	system start.
	system beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 20:12:16'!
tearDown

	system commit.
	system stop
	! !


!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:41:20'!
addressRecordWithLessThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:51:35'!
addressRecordWithMoreThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs,x'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:14:13'!
addressWithoutCustomerData

	^ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:53:41'!
customerRecordWithLessThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:55:59'!
customerRecordWithMoreThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444,x'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 20:02:57'!
emptyLine

	^ReadStream on: '
'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:34:25'!
invalidAddressRecordStartData

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
AA,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:22:55'!
invalidCustomerRecordStartData

	^ReadStream on: 'CC,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


!classDefinition: #SupplierTest category: #CustomerImporter!
TestCase subclass: #SupplierTest
	instanceVariableNames: 'system'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierTest methodsFor: 'SetUp/TearDown' stamp: 'LD 6/27/2024 20:45:05'!
setUp

	"system := Environment current createCustomerSystem."
	system := TransientSupplierSystem new.
	system start.
	"system beginTransaction."
! !

!SupplierTest methodsFor: 'SetUp/TearDown' stamp: 'LD 6/27/2024 21:13:39'!
tearDown

	"system commit."
	system stop
	! !


!SupplierTest methodsFor: 'Tests' stamp: 'LD 6/27/2024 20:18:13'!
test01ValidDataIsImportedCorrectly

	SupplierImporter valueFrom: self validImportData into: system.

	self assertSupplierIsImportedCorrectly.! !


!SupplierTest methodsFor: 'CSV' stamp: 'LD 6/27/2024 21:53:31'!
validImportData

	^ReadStream on: 
'S,Supplier1,D,123			
NC,Pepe,Sanchez,D,22333444			
EC,D,5456774
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'! !


!SupplierTest methodsFor: 'asserts' stamp: 'LD 6/27/2024 21:52:04'!
assertSupplierIsImportedCorrectly
	| importedSupplier|

	"importedSupplier := system supplierWithIdentificationType: 'D' number: '123'."
	importedSupplier := system supplierWithName: 'Supplier1'.

	self assert: 'Supplier1' equals: importedSupplier name.
	self assert: 'D' equals: importedSupplier idType.
	self assert: '123' equals: importedSupplier idNumber.

	^importedSupplier
! !


!classDefinition: #Address category: #CustomerImporter!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 17:55:46'!
isAt: aStreetName

	^streetName = aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName: aStreetName

	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber: aStreetNumber

	streetNumber := aStreetNumber ! !


!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !

!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town: aTown

	town := aTown! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode: aZipCode

	zipCode := aZipCode! !


!classDefinition: #CSVImporter category: #CustomerImporter!
Object subclass: #CSVImporter
	instanceVariableNames: 'readStream system line record'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CSVImporter methodsFor: 'initialization' stamp: 'LD 6/27/2024 20:07:01'!
initializeFrom: aReadStream into: aCustomerSystem

	readStream := aReadStream.
	system := aCustomerSystem ! !


!CSVImporter methodsFor: 'evaluating - private' stamp: 'LD 6/27/2024 20:52:39'!
assertRecordNotEmpty

	record isEmpty ifTrue: [ self error: self class invalidRecordTypeErrorDescription ]! !

!CSVImporter methodsFor: 'evaluating - private' stamp: 'LD 6/27/2024 21:56:57'!
createRecord

	^ record := line nextLine.! !

!CSVImporter methodsFor: 'evaluating - private' stamp: 'LD 6/27/2024 21:01:36'!
hasLineToImport

	line := readStream nextLine.
	^line notNil! !

!CSVImporter methodsFor: 'evaluating - private' stamp: 'LD 6/27/2024 21:01:43'!
importRecord

	self assertRecordNotEmpty.

	self isCustomerRecord ifTrue: [ ^self importCustomer ].
	self isAddressRecord ifTrue: [ ^self importAddress ].

	self error: self class invalidRecordTypeErrorDescription! !


!CSVImporter methodsFor: 'address' stamp: 'LD 6/27/2024 20:52:55'!
assertValidAddressRecord

	^ record size ~= 6 ifTrue: [ self error: self class invalidAddressRecordErrorDescription ]! !

!CSVImporter methodsFor: 'address' stamp: 'LD 6/27/2024 20:53:23'!
isAddressRecord

	^ record first = 'A'! !


!CSVImporter methodsFor: 'customer' stamp: 'LD 6/27/2024 20:53:08'!
assertValidCustomerRecord

	^ record size ~= 5 ifTrue: [ self error: self class invalidCustomerRecordErrorDescription ]! !


!CSVImporter methodsFor: 'evaluating' stamp: 'LD 6/27/2024 20:58:44'!
value

	[ self hasLineToImport ] whileTrue: [
		self createRecord.
		self importRecord ].

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CSVImporter class' category: #CustomerImporter!
CSVImporter class
	instanceVariableNames: ''!

!CSVImporter class methodsFor: 'instance creation' stamp: 'LD 6/27/2024 21:03:36'!
from: aReadStream into: aSystem

	^self new initializeFrom: aReadStream into: aSystem! !


!CSVImporter class methodsFor: 'importing' stamp: 'LD 6/27/2024 21:02:37'!
valueFrom: aReadStream into: aCustomerSystem

	self subclassResponsibility! !


!CSVImporter class methodsFor: 'error messages' stamp: 'LD 6/27/2024 20:14:25'!
canNotImportAddressWithoutCustomerErrorDescription

	^'Cannot import address without customer'! !

!CSVImporter class methodsFor: 'error messages' stamp: 'LD 6/27/2024 20:14:29'!
invalidAddressRecordErrorDescription

	^'Address record has to have six fields'! !

!CSVImporter class methodsFor: 'error messages' stamp: 'LD 6/27/2024 20:14:36'!
invalidCustomerRecordErrorDescription

	^'Invalid Customer record'! !

!CSVImporter class methodsFor: 'error messages' stamp: 'LD 6/27/2024 20:14:33'!
invalidRecordTypeErrorDescription

	^'Invalid record type'! !


!classDefinition: #CustomerImporter category: #CustomerImporter!
CSVImporter subclass: #CustomerImporter
	instanceVariableNames: 'newCustomer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!



!CustomerImporter methodsFor: 'customer' stamp: 'LD 6/27/2024 20:30:02'!
importCustomer

	self assertValidCustomerRecord.

	newCustomer := Customer new.
	newCustomer firstName: record second.
	newCustomer lastName: record third.
	newCustomer identificationType: record fourth.
	newCustomer identificationNumber: record fifth.
	system addCustomer: newCustomer! !

!CustomerImporter methodsFor: 'customer' stamp: 'HAW 5/22/2022 19:23:55'!
isCustomerRecord

	^ record first = 'C'! !


!CustomerImporter methodsFor: 'address' stamp: 'HAW 5/22/2022 19:58:41'!
assertCustomerWasImported

	^ newCustomer ifNil: [ self error: self class canNotImportAddressWithoutCustomerErrorDescription ]! !

!CustomerImporter methodsFor: 'address' stamp: 'HAW 5/22/2022 19:59:12'!
importAddress

	| newAddress |

	self assertCustomerWasImported.
	self assertValidAddressRecord.

	newAddress := Address new.
	newCustomer addAddress: newAddress.
	newAddress streetName: record second.
	newAddress streetNumber: record third asNumber .
	newAddress town: record fourth.
	newAddress zipCode: record fifth asNumber .
	newAddress province: record sixth! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: #CustomerImporter!
CustomerImporter class
	instanceVariableNames: ''!


!CustomerImporter class methodsFor: 'importing' stamp: 'LD 6/27/2024 21:02:37'!
valueFrom: aReadStream into: aCustomerSystem

	^(self from: aReadStream into: aCustomerSystem) value! !



!classDefinition: #SupplierImporter category: #CustomerImporter!
CSVImporter subclass: #SupplierImporter
	instanceVariableNames: 'newSupplier'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierImporter methodsFor: 'import' stamp: 'LD 6/27/2024 21:10:14'!
assertSupplierWasImported! !

!SupplierImporter methodsFor: 'import' stamp: 'LD 6/27/2024 21:10:35'!
importAddress
	"
	| newAddress |

	self assertSupplierWasImported.
	self assertValidAddressRecord.

	newAddress := Address new.
	newSupplier addAddress: newAddress.
	newAddress streetName: record second.
	newAddress streetNumber: record third asNumber .
	newAddress town: record fourth.
	newAddress zipCode: record fifth asNumber .
	newAddress province: record sixth
	"! !

!SupplierImporter methodsFor: 'import' stamp: 'LD 6/27/2024 21:07:51'!
importExistingCustomer! !

!SupplierImporter methodsFor: 'import' stamp: 'LD 6/27/2024 21:07:46'!
importNewCustomer! !

!SupplierImporter methodsFor: 'import' stamp: 'LD 6/27/2024 20:52:24'!
importRecord

	self assertRecordNotEmpty.

	self isSupplierRecord ifTrue: [ ^self importSupplier ].
	self isNewCustomerRecord ifTrue: [ ^self importNewCustomer ].
	self isExistingCustomerRecord ifTrue: [ ^self importExistingCustomer ].
	self isAddressRecord ifTrue: [ ^self importAddress ].


	self error: self class invalidRecordTypeErrorDescription! !

!SupplierImporter methodsFor: 'import' stamp: 'LD 6/27/2024 21:25:08'!
importSupplier
	"self assertValidSupplierRecord."

	newSupplier := Supplier new.
	newSupplier name: record second.
	newSupplier idType: record third.
	newSupplier idNumber: record fourth.
	system addSupplier: newSupplier.! !


!SupplierImporter methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 21:14:05'!
assertValidSupplierRecord

	^ record size ~= 4 ifTrue: [ self error: self class invalidSupplierRecordErrorDescription ]! !

!SupplierImporter methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 21:22:59'!
invalidSupplierRecordErrorDescription
	self error: 'invalidSupplierRecordError'! !

!SupplierImporter methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 20:53:47'!
isExistingCustomerRecord

	^ record first = 'EC'! !

!SupplierImporter methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 21:28:15'!
isNewCustomerRecord

	^ record first = 'NC'! !

!SupplierImporter methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 21:04:35'!
isSupplierRecord

	^ record first = 'S'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SupplierImporter class' category: #CustomerImporter!
SupplierImporter class
	instanceVariableNames: ''!

!SupplierImporter class methodsFor: 'importing' stamp: 'LD 6/27/2024 21:02:53'!
valueFrom: aReadStream into: aSupplierSystem

	^(self from: aReadStream into: aSupplierSystem) value! !



!classDefinition: #Customer category: #CustomerImporter!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'LD 6/27/2024 20:30:17'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 17:55:17'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 19:38:32'!
isAddressesEmpty

	^addresses isEmpty ! !


!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName

	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName: aName

	firstName := aName! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Customer methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!classDefinition: #CustomerSystem category: #CustomerImporter!
Object subclass: #CustomerSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerSystem methodsFor: 'customers' stamp: 'LD 6/27/2024 20:30:02'!
addCustomer: aCustomer

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:18:38'!
customerWithIdentificationType: anIdType number: anIdNumber

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:18:51'!
numberOfCustomers

	self subclassResponsibility ! !


!CustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:04'!
beginTransaction

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:16'!
commit

	self subclassResponsibility ! !


!CustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:10'!
start

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:13'!
stop

	self subclassResponsibility ! !


!CustomerSystem methodsFor: 'supplier' stamp: 'LD 6/27/2024 20:33:17'!
addSupplier: aSupplier

	self subclassResponsibility! !


!classDefinition: #PersistentCustomerSystem category: #CustomerImporter!
CustomerSystem subclass: #PersistentCustomerSystem
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'LD 6/27/2024 20:30:02'!
addCustomer: aCustomer

	^session persist: aCustomer ! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:09:50'!
customerWithIdentificationType: anIdType number: anIdNumber

	^(session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:08:47'!
numberOfCustomers

	^(session selectAllOfType: Customer) size! !


!PersistentCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:12:39'!
beginTransaction

	session beginTransaction.
! !

!PersistentCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:13:00'!
commit

	session commit ! !


!PersistentCustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 11/14/2023 09:21:54'!
start

	session := DataBaseSession for: (Array with: Address with: Customer).
	! !

!PersistentCustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 20:13:10'!
stop

	session close! !


!classDefinition: #TransientCustomerSystem category: #CustomerImporter!
CustomerSystem subclass: #TransientCustomerSystem
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientCustomerSystem methodsFor: 'system lifecycle' stamp: 'LD 6/27/2024 20:42:09'!
start

	customers := OrderedCollection new.
! !

!TransientCustomerSystem methodsFor: 'system lifecycle' stamp: 'LD 6/27/2024 20:41:51'!
stop

	customers := nil.
! !


!TransientCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:21:20'!
beginTransaction

	! !

!TransientCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:23:01'!
commit

	! !


!TransientCustomerSystem methodsFor: 'customers' stamp: 'LD 6/27/2024 20:31:29'!
addCustomer: aCustomer

	customers add: aCustomer ! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'LD 6/27/2024 20:27:39'!
customerWithIdentificationType: anIdType number: anIdNumber

	^customers detect: [ :aCustomer| aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:21:43'!
numberOfCustomers

	^customers size! !



!classDefinition: #DataBaseSession category: #CustomerImporter!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id inTransaction closed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:25'!
beginTransaction

	inTransaction := true.! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:18'!
commit

	inTransaction := false.! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 11/14/2023 08:52:30'!
close

	closed := true.! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:49:30'!
assertCanUseDatabase

	self assertIsOpen.
	self assertInTransaction ! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:43'!
assertInTransaction

	inTransaction ifFalse: [ self error: 'Not in transaction' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:16'!
assertIsOpen

	closed ifTrue: [ self error: 'Connection with database closed' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:09:07'!
assertTypeIsPersisted: aType

	(configuration includes: aType) ifFalse: [ self error: 'Object of type ', aType name, ' are not configured to be persisted' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
isRelationToPersist: possibleRelation

	^ possibleRelation class = Set! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
persistPossibleRelationOf: anObject at: anInstVarOffset

	| possibleRelation |
		
	possibleRelation := anObject instVarAt: anInstVarOffset.
	(self isRelationToPersist: possibleRelation) ifTrue: [ self persistRelationOf: anObject at: anInstVarOffset with: possibleRelation ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:03'!
persistRelationOf: anObject at: anInstVarOffset with: aRelation

	| persistentRelation |
	
	persistentRelation := PersistentSet on: self from: aRelation.
	anObject instVarAt: anInstVarOffset put: persistentRelation! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:34'!
persistRelationsOf: anObject

	anObject class instVarNamesAndOffsetsDo: [ :anInstVarName :anInstVarOffset | self persistPossibleRelationOf: anObject at: anInstVarOffset]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:06:24'!
tableOfType: aType

	^ tables at: aType ifAbsentPut: [ Set new ]! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:44:19'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.
	inTransaction := false.
	closed := false.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'LD 6/27/2024 20:30:02'!
persist: anObject

	| table |

	self assertCanUseDatabase.
	self assertTypeIsPersisted: anObject class.
	self delay.
	
	table := self tableOfType: anObject class.
	self defineIdOf: anObject.
	table addCustomer: anObject.
	self persistRelationsOf: anObject.
! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:06:56'!
select: aCondition ofType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:07:12'!
selectAllOfType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: #CustomerImporter!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !


!classDefinition: #Environment category: #CustomerImporter!
Object subclass: #Environment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Environment methodsFor: 'customer system' stamp: 'HAW 5/22/2022 21:41:06'!
createCustomerSystem

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Environment class' category: #CustomerImporter!
Environment class
	instanceVariableNames: ''!

!Environment class methodsFor: 'current' stamp: 'HAW 5/22/2022 21:37:10'!
current

	^(self subclasses detect: [ :anEnvironmentClass | anEnvironmentClass isCurrent ]) new! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:46'!
environmentKey

	^ #ENV! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:46'!
environmentVariable

	^ Smalltalk at: self environmentKey! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:09'!
identifier

	self subclassResponsibility! !

!Environment class methodsFor: 'current' stamp: 'HAW 5/22/2022 21:41:36'!
isCurrent

	self subclassResponsibility ! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:46:01'!
makeCurrent

	"
	Tener en cuenta que en Smalltalk se podría poner directamente la clase de environment,
	esto es DevelopmentEnvironment o IntegrationEnvironmet o hasta una instancia de ellas,
	pero se está simulando el hecho de que esto esté definido por fuera del sistema, como una
	variable del sistema operativo - Hernan"
	
	Smalltalk at: self environmentKey put: self identifier! !


!classDefinition: #DevelopmentEnvironment category: #CustomerImporter!
Environment subclass: #DevelopmentEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DevelopmentEnvironment methodsFor: 'customer system' stamp: 'HAW 5/22/2022 21:38:39'!
createCustomerSystem

	^TransientCustomerSystem new! !

!DevelopmentEnvironment methodsFor: 'customer system' stamp: 'LD 6/27/2024 20:39:58'!
createSupplierSystem

	^TransientSupplierSystem new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DevelopmentEnvironment class' category: #CustomerImporter!
DevelopmentEnvironment class
	instanceVariableNames: ''!

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:42:50'!
identifier

	^ #DEV! !

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:43:52'!
isCurrent

	"
	self makeCurrent
	"
	^self environmentVariable = self identifier! !


!classDefinition: #IntegrationEnvironment category: #CustomerImporter!
Environment subclass: #IntegrationEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!IntegrationEnvironment methodsFor: 'customer system' stamp: 'HAW 5/22/2022 21:40:48'!
createCustomerSystem

	^PersistentCustomerSystem new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IntegrationEnvironment class' category: #CustomerImporter!
IntegrationEnvironment class
	instanceVariableNames: ''!

!IntegrationEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:43:07'!
identifier

	^ #INT! !

!IntegrationEnvironment class methodsFor: 'current' stamp: 'LD 6/27/2024 20:03:29'!
isCurrent

	
	self makeCurrent

	^self environmentVariable = self identifier! !


!classDefinition: #Supplier category: #CustomerImporter!
Object subclass: #Supplier
	instanceVariableNames: 'name idType idNumber'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Supplier methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 20:47:40'!
idNumber
	^idNumber! !

!Supplier methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 20:47:52'!
idNumber: aNumber
	idNumber := aNumber! !

!Supplier methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 20:47:31'!
idType
	^idType! !

!Supplier methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 20:47:25'!
idType: aIDType
	idType := aIDType! !

!Supplier methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 21:21:15'!
initialize

	super initialize.! !

!Supplier methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 20:46:46'!
name
	^name! !

!Supplier methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 20:47:02'!
name: aName
	name := aName! !


!classDefinition: #TransientSupplierSystem category: #CustomerImporter!
ProtoObject subclass: #TransientSupplierSystem
	instanceVariableNames: 'suppliers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientSupplierSystem methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 20:41:06'!
addSupplier: aSupplier

	suppliers add: aSupplier ! !

!TransientSupplierSystem methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 20:41:43'!
start

	suppliers := OrderedCollection new.! !

!TransientSupplierSystem methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 20:41:58'!
stop

	suppliers := nil.! !

!TransientSupplierSystem methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 21:10:56'!
supplierWithIdentificationType: anIdType number: anIdNumber

	^suppliers detect: [ :aSupplier | aSupplier idType = anIdType and: [ aSupplier idNumber = anIdNumber ]]! !

!TransientSupplierSystem methodsFor: 'as yet unclassified' stamp: 'LD 6/27/2024 21:23:41'!
supplierWithName: aName
	^suppliers detect: [ :aSupplier | aSupplier name = aName]! !
