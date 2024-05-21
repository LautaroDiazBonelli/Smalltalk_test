!classDefinition: #PortfolioTest category: #'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'tests' stamp: 'ssc 10/6/2022 21:44:56'!
test01PortfolioHasZeroAsBalanceWhenCreated

	| portfolio |
	
	portfolio := Portfolio new.
	
	self assert: 0 equals: portfolio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/17/2022 15:49:55'!
test02PortfolioWithReceptiveAccountsBalanceIsTheSumOfItsAccountsBalance

	| portfolio account1 account2 |
	
	portfolio := Portfolio new.
	account1 := self createAccountWithBalance: 200.
	account2 := self createAccountWithBalance: 300.
	
	portfolio add: account1;
	             add: account2.
	
	self assert: 500 equals: portfolio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/17/2022 15:49:55'!
test03PortfolioWithPortfoliosBalanceIsTheSumOfItsInsidePortfoliosBalance

	| portfolioParent childPortfolio1 childPortfolio2 account1 account2 |
	
	portfolioParent := Portfolio new.	
	childPortfolio1 := Portfolio new.
	childPortfolio2 := Portfolio new.
	account1 := self createAccountWithBalance: 300.
	account2 := self createAccountWithBalance: -200.
	
	portfolioParent add: childPortfolio1;
		add: childPortfolio2.
	childPortfolio1 add: account1.
	childPortfolio2 add: account2.
			
	self assert: 100 equals: portfolioParent balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/17/2022 15:50:40'!
test04PortfolioDoesNotRecognizeNotRegisteredTransactions

	| portfolio transaction |
	
	portfolio := Portfolio new.	
	transaction := self createDeposit: 200 on: ReceptiveAccount new.
	
	self deny: (portfolio hasRegistered: transaction)! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/17/2022 15:50:51'!
test05PortfolioRecognizesItsAccountsTransactions

	| portfolio deposit withdraw account1 account2 |
	
	portfolio := Portfolio new.	
	deposit := self createDeposit: 200.
	withdraw := self createWithdraw: 100.
	account1 := self createAccountWithTransaction: deposit.
	account2 := self createAccountWithTransaction: withdraw.

	portfolio add: account1;
		      add: account2.
	
	self assert: (portfolio hasRegistered: deposit).
	self assert: (portfolio hasRegistered: withdraw).! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/17/2022 15:50:27'!
test06PortfolioRecognizesItsPortfoliosTransactions

	| portfolio childPortfolio transaction account |
	
	portfolio := Portfolio new.	
	childPortfolio := Portfolio new.	
	transaction := self createDeposit: 200.
	account := self createAccountWithTransaction: transaction.
	
	childPortfolio add: account.
	portfolio add: childPortfolio.
	
	self assert: (portfolio hasRegistered: transaction)! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/15/2022 12:30:38'!
test07PortfolioHasNoTransactionsWhenCreated

	| portfolio |
	
	portfolio := Portfolio new.
	
	self assert: portfolio transactions isEmpty.! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/17/2022 15:51:43'!
test08PortfolioHasItsAccountsTransactions

	| portfolio account1 account2 deposit withdraw transactions |
	
	portfolio := Portfolio new.
	deposit := self createDeposit: 200.
	withdraw := self createWithdraw: 100.
	
	account1 := self createAccountWithTransaction: deposit.
	account2 := self createAccountWithTransaction: withdraw.

	portfolio add: account1;
			add: account2.

	transactions := portfolio transactions.
	
	self assert: transactions includes: deposit.
	self assert: transactions includes: withdraw.
	self assert: transactions size equals: 2.! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/17/2022 15:53:35'!
test09PortfolioHasItsPortfoliosTransactions

	| account1 account2 deposit withdraw transactions childPortfolio1 childPortfolio2 portfolioParent |
	
	portfolioParent := Portfolio new.	
	childPortfolio1 := Portfolio new.
	childPortfolio2 := Portfolio new.
	deposit := self createDeposit: 200.
	withdraw := self createWithdraw: 300.

	account1 := self createAccountWithTransaction: deposit.
	account2 := self createAccountWithTransaction: withdraw.
	
	portfolioParent add: childPortfolio1;
		add: childPortfolio2.
	childPortfolio1 add: account1.
	childPortfolio2 add: account2.
	
	transactions := portfolioParent transactions.
	
	self assert: transactions includes: deposit.
	self assert: transactions includes: withdraw.
	self assert: transactions size equals: 2.! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/15/2022 16:16:14'!
test10CannotAddSameServiceTwice

	| account portfolio |
	
	portfolio := Portfolio new.	
	account := ReceptiveAccount new.
	
	portfolio add: account.
	
	self should: [portfolio add: account.]
		raise: Error - MessageNotUnderstood
		withMessageText: Portfolio cannotAddServiceErrorDescription.! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/15/2022 16:38:26'!
test11CannotAddServiceThatWasAlreadyDescendant

	| account portfolio childPortfolio |
	
	portfolio := Portfolio new.	
	childPortfolio := Portfolio new.	
	account := ReceptiveAccount new.
	
	childPortfolio add: account.
	portfolio add: childPortfolio.
	
	self should: [portfolio add: account.]
		raise: Error - MessageNotUnderstood
		withMessageText: Portfolio cannotAddServiceErrorDescription.! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/15/2022 16:42:45'!
test12CannotAddPortfolioToItself

	| portfolio |
	
	portfolio := Portfolio new.	
	
	self should: [portfolio add: portfolio.]
		raise: Error - MessageNotUnderstood
		withMessageText: Portfolio cannotAddServiceErrorDescription.! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/15/2022 17:01:05'!
test13CannotAddPortfolioWithDescendantAlreadyInTree

	| account portfolio childPortfolio |
	
	portfolio := Portfolio new.	
	childPortfolio := Portfolio new.	
	account := ReceptiveAccount new.
	
	childPortfolio add: account.
	portfolio add: account.
	
	self should: [portfolio add: childPortfolio.]
		raise: Error - MessageNotUnderstood
		withMessageText: Portfolio cannotAddServiceErrorDescription.
! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/15/2022 18:11:55'!
test14CannotAddServiceAlreadyInParentsTree

	| account portfolio childPortfolio |
	
	portfolio := Portfolio new.	
	childPortfolio := Portfolio new.	
	account := ReceptiveAccount new.
	
	portfolio add: childPortfolio.
	portfolio add: account.
	
	self should: [	childPortfolio add: account.]
		raise: Error - MessageNotUnderstood
		withMessageText: Portfolio cannotAddServiceErrorDescription.
! !

!PortfolioTest methodsFor: 'tests' stamp: 'mnd 10/15/2022 18:52:12'!
test15CannotAddServiceAlreadyInAnyAscendantsTree

	| account portfolio childPortfolio grandChildPortfolio |
	
	portfolio := Portfolio new.	
	childPortfolio := Portfolio new.	
	grandChildPortfolio := Portfolio new.
	account := ReceptiveAccount new.
	
	childPortfolio add: grandChildPortfolio.
	portfolio add: childPortfolio.
	portfolio add: account.
	
	self should: [	grandChildPortfolio add: account.]
		raise: Error - MessageNotUnderstood
		withMessageText: Portfolio cannotAddServiceErrorDescription.
! !


!PortfolioTest methodsFor: 'setUp' stamp: 'mnd 10/17/2022 15:50:59'!
createAccountWithBalance: aBalance

	| account |
	
	account := ReceptiveAccount new.
	aBalance positive ifTrue: [
		self createDeposit: aBalance on: account.
	] ifFalse: [
		self createWithdraw: aBalance negated on: account.
	].
	^ account! !

!PortfolioTest methodsFor: 'setUp' stamp: 'mnd 10/17/2022 15:50:10'!
createAccountWithTransaction: aTransaction

	| account |
	
	account := ReceptiveAccount new.
	account register: aTransaction.
	^ account! !

!PortfolioTest methodsFor: 'setUp' stamp: 'mnd 10/17/2022 15:50:27'!
createDeposit: amount

	^ Deposit for: amount! !

!PortfolioTest methodsFor: 'setUp' stamp: 'mnd 10/17/2022 15:50:40'!
createDeposit: amount on: account1

	^ Deposit register: amount on: account1! !

!PortfolioTest methodsFor: 'setUp' stamp: 'mnd 10/17/2022 15:50:51'!
createWithdraw: amount

	^ Withdraw for: amount! !

!PortfolioTest methodsFor: 'setUp' stamp: 'mnd 10/17/2022 15:50:59'!
createWithdraw: amount on: account2

	^ Withdraw register: amount on: account2! !


!classDefinition: #ReceptiveAccountTest category: #'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/17/2021 17:29:53'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #TransferTest category: #'Portfolio-Ejercicio'!
TestCase subclass: #TransferTest
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!TransferTest methodsFor: 'testing' stamp: 'L 5/20/2024 21:19:23'!
test01TransferImpactBalance

	| extractionAccount depositAccount |
	
	extractionAccount := ReceptiveAccount new.
	depositAccount := ReceptiveAccount new.
	
	TransferLegs register: 100 from: extractionAccount to: depositAccount.

	self assert: -100 equals: extractionAccount balance.
	self assert: 100 equals: depositAccount balance.
! !

!TransferTest methodsFor: 'testing' stamp: 'L 5/20/2024 21:19:23'!
test02ExtractedAccountHasRegisteredTransfer
	| extractionAccount depositAccount transferTransaction|
	
	extractionAccount := ReceptiveAccount new.
	depositAccount := ReceptiveAccount new.
	
	transferTransaction := TransferLegs register: 100 from: extractionAccount to: depositAccount.
	
	self assert: (extractionAccount hasRegistered: transferTransaction).

	
! !

!TransferTest methodsFor: 'testing' stamp: 'L 5/20/2024 21:19:23'!
test03DepositAccountKnowsExtractedAccount
	| extractionAccount depositAccount transferTransaction|
	
	extractionAccount := ReceptiveAccount new.
	depositAccount := ReceptiveAccount new.
	
	transferTransaction := TransferLegs register: 100 from: extractionAccount to: depositAccount.
	
	self assert: (depositAccount hasRegistered: transferTransaction).! !

!TransferTest methodsFor: 'testing' stamp: 'L 5/20/2024 21:19:23'!
test04TransactionKnowsDepositedAndExtractedAccounts

	| extractionAccount depositAccount transferTransaction|
	
	extractionAccount := ReceptiveAccount new.
	depositAccount := ReceptiveAccount new.
	
	transferTransaction := TransferLegs register: 100 from: extractionAccount to: depositAccount.
	self assert: (transferTransaction deposited)
	
! !


!classDefinition: #AccountTransaction category: #'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance impact' stamp: 'ssc 10/6/2022 21:37:17'!
impactOnBalance: aBalance

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: #'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: #'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance impact' stamp: 'ssc 10/6/2022 21:37:30'!
impactOnBalance: aBalance

	^aBalance + value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: #'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: #'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance impact' stamp: 'ssc 10/6/2022 21:37:40'!
impactOnBalance: aBalance

	^aBalance - value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: #'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #FinancialService category: #'Portfolio-Ejercicio'!
Object subclass: #FinancialService
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!FinancialService methodsFor: 'balance' stamp: 'mnd 10/15/2022 15:04:19'!
balance

	^ self subclassResponsibility.! !


!FinancialService methodsFor: 'transactions' stamp: 'mnd 10/15/2022 15:05:12'!
addTransactionsTo: collectionOfTransactions 

	^ self subclassResponsibility.! !

!FinancialService methodsFor: 'transactions' stamp: 'mnd 10/15/2022 15:04:16'!
hasRegistered: aTransaction

	^ self subclassResponsibility.! !

!FinancialService methodsFor: 'transactions' stamp: 'mnd 10/15/2022 15:05:16'!
transactions 

	^ self subclassResponsibility.! !


!FinancialService methodsFor: 'validations - private' stamp: 'mnd 10/17/2022 16:01:19'!
containsService: aFinancialService 
	
	^ self subclassResponsibility.! !


!FinancialService methodsFor: 'validations' stamp: 'mnd 10/17/2022 16:03:43'!
canBeAddedTo: rootPortfolio 

	^ self subclassResponsibility.! !


!FinancialService methodsFor: 'adding - private' stamp: 'mnd 10/17/2022 16:01:10'!
addParentPortfolio: aPortfolio 

	^ self subclassResponsibility.! !


!classDefinition: #Portfolio category: #'Portfolio-Ejercicio'!
FinancialService subclass: #Portfolio
	instanceVariableNames: 'financialServices parentPortfolios'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'balance' stamp: 'mnd 10/15/2022 16:03:13'!
balance
	
	^ financialServices sum: [ :financialService | financialService balance ]
		ifEmpty: 0.
! !


!Portfolio methodsFor: 'initialization' stamp: 'mnd 10/15/2022 18:41:44'!
initialize

	financialServices := OrderedCollection new.
	parentPortfolios := OrderedCollection new.
! !


!Portfolio methodsFor: 'adding' stamp: 'mnd 10/15/2022 19:04:55'!
add: aFinancialService
	self validateServiceCanBeAdded: aFinancialService.

	financialServices add: aFinancialService.
	aFinancialService addParentPortfolio: self.
! !


!Portfolio methodsFor: 'transactions' stamp: 'mnd 10/15/2022 13:25:06'!
addTransactionsTo: collectionOfTransactions 
	
	collectionOfTransactions addAll: self transactions.! !

!Portfolio methodsFor: 'transactions' stamp: 'mnd 10/15/2022 16:03:32'!
hasRegistered: aTransaction
	
	^ financialServices anySatisfy: [ :financialService | financialService hasRegistered: aTransaction ].
	! !

!Portfolio methodsFor: 'transactions' stamp: 'mnd 10/15/2022 16:03:43'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	financialServices do: [ :financialService | financialService addTransactionsTo: transactions].
	
	^transactions! !


!Portfolio methodsFor: 'validations - private' stamp: 'mnd 10/17/2022 16:03:25'!
canAdd: aFinancialService

	^ self rootPortfolios allSatisfy: [ :rootPortfolio | aFinancialService canBeAddedTo: rootPortfolio ]! !

!Portfolio methodsFor: 'validations - private' stamp: 'mnd 10/15/2022 16:44:09'!
containsService: aFinancialService 
	^ self = aFinancialService or: [
		financialServices anySatisfy: [ :service | service containsService: aFinancialService ]].! !

!Portfolio methodsFor: 'validations - private' stamp: 'mnd 10/15/2022 19:07:21'!
rootPortfolios
	
	parentPortfolios ifEmpty: [ ^ OrderedCollection with: self].
	^ (parentPortfolios collect: [ :aParent | aParent rootPortfolios ]) flatten.! !


!Portfolio methodsFor: 'validations' stamp: 'mnd 10/17/2022 16:03:09'!
canBeAddedTo: rootPortfolio 
	
	^ (rootPortfolio containsService: self) not and: [
		financialServices allSatisfy: [ :service | service canBeAddedTo: rootPortfolio ].
	].! !

!Portfolio methodsFor: 'validations' stamp: 'mnd 10/15/2022 19:04:55'!
validateServiceCanBeAdded: aFinancialService

	^ (self canAdd: aFinancialService)
		ifFalse: [ self error: self class cannotAddServiceErrorDescription]! !


!Portfolio methodsFor: 'adding - private' stamp: 'mnd 10/15/2022 18:41:44'!
addParentPortfolio: aPortfolio 
	parentPortfolios add: aPortfolio.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: #'Portfolio-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'error descriptions' stamp: 'mnd 10/15/2022 16:19:22'!
cannotAddServiceErrorDescription
	^ 'Service could not be added, because it already existed in related portfolio'.! !


!classDefinition: #ReceptiveAccount category: #'Portfolio-Ejercicio'!
FinancialService subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'mnd 10/15/2022 12:56:30'!
addTransactionsTo: collectionOfTransactions 

	collectionOfTransactions addAll: transactions.! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'mnd 10/15/2022 15:02:22'!
balance
	
	^transactions inject: 0 into: [ :balance :aTransaction | aTransaction impactOnBalance: balance ]
! !



!ReceptiveAccount methodsFor: 'validations - private' stamp: 'mnd 10/15/2022 16:36:43'!
containsService: aFinancialService 
	^ self = aFinancialService.! !


!ReceptiveAccount methodsFor: 'validations' stamp: 'mnd 10/17/2022 16:02:45'!
canBeAddedTo: rootPortfolio 
	^ (rootPortfolio containsService: self) not.! !


!ReceptiveAccount methodsFor: 'adding - private' stamp: 'mnd 10/15/2022 18:42:33'!
addParentPortfolio: aPortfolio 
	
	^ self! !


!classDefinition: #TransferLegs category: #'Portfolio-Ejercicio'!
Object subclass: #TransferLegs
	instanceVariableNames: 'value extracted deposited'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!TransferLegs methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:57:47'!
deposited
	^deposited ! !

!TransferLegs methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:57:41'!
extracted
	^extracted! !

!TransferLegs methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:54:19'!
initalizeFor: aValue from: aExtractionAccount to: aDepositAccount
	value := aValue.
	extracted := aExtractionAccount.
	deposited := aDepositAccount.! !

!TransferLegs methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:57:31'!
value
	^value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferLegs class' category: #'Portfolio-Ejercicio'!
TransferLegs class
	instanceVariableNames: 'depositLeg extractionLeg'!

!TransferLegs class methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:53:23'!
for: aValue from: aExtractionAccount to: aDepositAccount
	^self new initalizeFor: aValue from: aExtractionAccount to: aDepositAccount.! !

!TransferLegs class methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 21:30:03'!
register: aValue  from: aExtractionAccount to: aDepositAccount

	| extractionTransaction depositTransaction transaction |
	
	transaction := self for: aValue from: aExtractionAccount to: aDepositAccount.
	
	extractionTransaction := TransferExtraction transaction: transaction.
	depositTransaction := TransferDeposit transaction: transaction.
	
	depositLeg := depositTransaction.
	extractionLeg := extractionTransaction.
	
	
	"falta hace un getter de depositLeg y extractedLeg y despues en test02 ver si las legs estan en el hasRegistered"

	aExtractionAccount register: extractionTransaction.
	aDepositAccount register: depositTransaction.
	
	^transaction.
! !


!classDefinition: #TransferDeposit category: #'Portfolio-Ejercicio'!
TransferLegs subclass: #TransferDeposit
	instanceVariableNames: 'transaction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!TransferDeposit methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:35:33'!
extractedFrom
	^extractionAccount
	! !

!TransferDeposit methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:19:50'!
impactOnBalance: aBalance
	^aBalance + value! !

!TransferDeposit methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:29:05'!
initalizeFor: aValue from: aExtractionAccount
	value := aValue! !

!TransferDeposit methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:59:45'!
initializeWith: aTransaction 
	transaction  := aTransaction ! !

!TransferDeposit methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:54:53'!
value
	^transaction value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferDeposit class' category: #'Portfolio-Ejercicio'!
TransferDeposit class
	instanceVariableNames: ''!

!TransferDeposit class methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:30:05'!
for: aValue from: aExtractionAccount
	^self new initalizeFor: aValue from: aExtractionAccount! !

!TransferDeposit class methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:59:22'!
transaction: aTransaction
	self new initializeWith: aTransaction ! !


!classDefinition: #TransferExtraction category: #'Portfolio-Ejercicio'!
TransferLegs subclass: #TransferExtraction
	instanceVariableNames: 'transaction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!TransferExtraction methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:35:51'!
depositedFrom
	^depositAccount! !

!TransferExtraction methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:31:00'!
impactOnBalance: aBalance

	^aBalance - value! !

!TransferExtraction methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:28:43'!
initalizeFor: aValue to: aDepositAccount
	value := aValue! !

!TransferExtraction methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:59:49'!
initializeWith: aTransaction 
	transaction  := aTransaction ! !

!TransferExtraction methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:54:48'!
value
	^transaction value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferExtraction class' category: #'Portfolio-Ejercicio'!
TransferExtraction class
	instanceVariableNames: ''!

!TransferExtraction class methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:30:10'!
for: aValue to: aDepositAccount
	^self new initalizeFor: aValue to: aDepositAccount! !

!TransferExtraction class methodsFor: 'as yet unclassified' stamp: 'L 5/20/2024 20:59:27'!
transaction: aTransaction
	self new initializeWith: aTransaction ! !
