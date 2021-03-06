# Last modified December 7, 2012 by Richard Payne
#--------------------------------------------

.onAttach <- function(libname, pkgname){
  if (!interactive()) return()
  Rcmdr <- options()$Rcmdr
  plugins <- Rcmdr$plugins
  if ((!pkgname %in% plugins) && !getRcmdr("autoRestart")) {
    Rcmdr$plugins <- c(plugins, pkgname)
    options(Rcmdr=Rcmdr)
    closeCommander(ask=FALSE, ask.save=TRUE)
    Commander()
  }
}

# Run John Fox's findGlobals.R to generate this code
if (getRversion() >= '2.15.1') globalVariables(c('top',
'singleProportionTest', 'buttonsFrame',
'proportionalOddsModel', 'subsetVariable', 'lhsVariable',
'rhsVariable', 'modelTypeVariable', 'xBox',
'outerOperatorsFrame', 'formulaFrame', 'subsetFrame',
'modelTypeFrame', 'lhsEntry'))

# Addition by Richard Payne
if (getRversion() >= '2.15.1') globalVariables(c('onHelp','alternativeVariable','variancesVariable','.groupsLabel','alternativeFrame','variancesFrame','testVariable','testFrame','percentsVariable','chisqTestVariable','chisqComponentsVariable','expFreqVariable','fisherTestVariable','.Test','.Table','percentsFrame','testsFrame'))




# Example dialog-less menu item
#--------------------------------
# helloWorld <- function() {
#   command <- paste('print("Hello world!")')
#   doItAndPrint(command)
# }
# 

# Example dialog
#-----------------
# helloWorldDialog <- function() {
#   initializeDialog(title=gettextRcmdr("Hello World Dialog"))
#   nameVar <- tclVar("world")
#   nameEntry <- tkentry(top, width="15", textvariable=nameVar)
#   
#   onOK <- function() {
#     closeDialog()
#     name <- as.character(tclvalue(nameVar))
#     command <- paste("print('Hello ", name, "!')", sep="")
#     doItAndPrint(command)
#     tkfocus(CommanderWindow())
#   }
#   
#   OKCancelHelp(helpSubject="lm")
#   tkgrid(tklabel(top, text="Say hello to "), nameEntry, sticky="e")
#   tkgrid.configure(nameEntry, sticky="w")
#   tkgrid(buttonsFrame, sticky="w", columnspan=2)
#   dialogSuffix(rows=4, columns=2, focus=nameEntry)
# }
