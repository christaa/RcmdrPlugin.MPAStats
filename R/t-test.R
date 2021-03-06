# Modified on June 13, 2013 by Christa Schank

# Interpretation function
singleTTestWords <- function(x){
    wrapper <- function(text){
        text2 <- strwrap(text)
        for(i in 1:length(text2)){
            cat(text2[i],"\n",sep="")
        }
    }

    varcut <- nchar(ActiveDataSet())+2
    
    compare=paste(x$alternative," than ",sep="")
    if(compare == "two.sided than "){
        compare="different from "
    }


    pval=x$p.value
    alpha=1-attr(x$conf.int,"conf.level")


    if(pval < alpha){
        .not=""
    }
    if(pval > alpha){
        .not="not "
    }

    text <- paste("The mean ",tolower(substring(x$data.name,varcut))
        ," is ",.not,"significantly ",compare, x$null.value,". (t=",round(x$statistic,3)," p=",round(x$p.value,3),"). \n",sep="") 
    wrapper(text)
}

# Modified singleSampleTTest function from Rcmdr: R Commander
singleSampleTTest2 <- function () {
	defaults <- list (initial.x = NULL, initial.alternative = "two.sided", initial.level = ".95", 
			initial.mu = "0.0")
	dialog.values <- getDialog ("singleSampleTTest2", defaults)  
	initializeDialog(title = gettextRcmdr("Single-Sample t-Test"))
	xBox <- variableListBox(top, Numeric(), title = gettextRcmdr("Variable (pick one)"),
			initialSelection = varPosn(dialog.values$initial.x, "numeric"))
	onOK <- function() {
		x <- getSelection(xBox)
		if (length(x) == 0) {
			errorCondition(recall = singleSampleTTest2, message = gettextRcmdr("You must select a variable."))
			return()
		}
		alternative <- as.character(tclvalue(alternativeVariable))
		level <- tclvalue(confidenceLevel)
    	mu <- tclvalue(muVariable)
		putDialog ("singleSampleTTest2", list (initial.x = x, initial.alternative = alternative, 
						initial.level = level, initial.mu = mu))
		closeDialog()
                # Inserted "t.test <-"
		doItAndPrint(paste("t.test1 <- t.test(", ActiveDataSet(), "$", x, 
						", alternative='", alternative, "', mu=", mu, ", conf.level=", 
						level, ")", sep = ""))
                # Inserted Code:
                doItAndPrint("t.test1")
                doItAndPrint("singleTTestWords(t.test1)")
                # End Inserted Code
		tkdestroy(top)
		tkfocus(CommanderWindow())
	}
	OKCancelHelp(helpSubject = "t.test", reset = "singleSampleTTest2")
	radioButtons(top, name = "alternative", buttons = c("twosided", 
					"less", "greater"), values = c("two.sided", "less", "greater"), 
			labels = gettextRcmdr(c("Population mean != mu0", "Population mean < mu0", 
							"Population mean > mu0")), title = gettextRcmdr("Alternative Hypothesis"),
			initialValue = dialog.values$initial.alternative)
	rightFrame <- tkframe(top)
	confidenceFrame <- tkframe(rightFrame)
	confidenceLevel <- tclVar(dialog.values$initial.level)
	confidenceField <- ttkentry(confidenceFrame, width = "6", 
			textvariable = confidenceLevel)
	muFrame <- tkframe(rightFrame)
	muVariable <- tclVar(dialog.values$initial.mu)
	muField <- ttkentry(muFrame, width = "8", textvariable = muVariable)
	tkgrid(getFrame(xBox), sticky = "nw")
	tkgrid(labelRcmdr(rightFrame, text = ""), sticky = "w")
	tkgrid(labelRcmdr(muFrame, text = gettextRcmdr("Null hypothesis: mu = ")), 
			muField, sticky = "w")
	tkgrid(muFrame, sticky = "w")
	tkgrid(labelRcmdr(confidenceFrame, text = gettextRcmdr("Confidence Level: ")), 
			confidenceField, sticky = "w")
	tkgrid(confidenceFrame, sticky = "w")
	tkgrid(alternativeFrame, rightFrame, sticky = "nw")
	tkgrid(buttonsFrame, columnspan = 2, sticky = "w")
	tkgrid.configure(confidenceField, sticky = "e")
	dialogSuffix(rows = 4, columns = 2)
}


# Interpretation Function
pairedTTestWords=function(x){
    wrapper <- function(text){
        text2 <- strwrap(text)
        for(i in 1:length(text2)){
            cat(text2[i],"\n",sep="")
        }
    }


    prelim.names <- strsplit(x$data.name," ")[[1]][c(1,3)]
    one.pos <- which(strsplit(prelim.names,"")[[1]]=="$") + 1
    names <- substring(prelim.names[1],one.pos)

    two.pos <- which(strsplit(prelim.names,"")[[2]]=="$") + 1
    names[2] <- substring(prelim.names[2],two.pos)
        grp1 <- names[1]
        grp2 <- names[2]
    t.value <- x$statistic
    pval <- x$p.value
    conf.level <- 100*attr(x$conf.int,"conf.level")
    alpha <- 1-attr(x$conf.int,"conf.level")

    l.conf <- x$conf.int[1]
    u.conf <- x$conf.int[2]
    
    up.down <- paste(x$alternative," than ",sep="")
    if(x$alternative == "two.sided"){
        one.two <- "two"
        up.down <- "different from "
    }
    else if(x$alternative != "two.sided"){
        one.two <- "one"
    }

    if(pval >= alpha){
        text <- paste("The mean difference of ",grp1," - ",grp2," is not significantly ",up.down,"0. (t=",round(t.value,3),", p=",round(pval,3)," for a ",one.two,"-tailed test).",sep="")
        wrapper(text)
    }
    else if(pval < alpha){
        text <- paste("It appears that the mean difference of ",grp1," - ",grp2," is ",up.down,"0. The true mean difference for ",grp1," -  ",grp2, " is likely between ",round(l.conf,2)," and ",round(u.conf,2),". (",conf.level,"% confidence, t=",round(t.value,3),", p=",round(pval,3)," for a ",one.two,"-tailed test). \n \n",sep="")
    wrapper(text)
    }

}    

# Modifed pairedTTest from Rcmdr: R Commander
pairedTTest2 <- function () {
	defaults <- list(initial.x = NULL, initial.y = NULL, initial.alternative = "two.sided", 
			initial.confidenceLevel = ".95")
	dialog.values <- getDialog("pairedTTest2", defaults)
	initializeDialog(title = gettextRcmdr("Paired t-Test"))
	.numeric <- Numeric()
	xBox <- variableListBox(top, .numeric, title = gettextRcmdr("First variable (pick one)"),
			initialSelection = varPosn(dialog.values$initial.x, "numeric"))
	yBox <- variableListBox(top, .numeric, title = gettextRcmdr("Second variable (pick one)"),
			initialSelection = varPosn(dialog.values$initial.y, "numeric"))
	onOK <- function() {
		x <- getSelection(xBox)
		y <- getSelection(yBox)
		if (length(x) == 0 | length(y) == 0) {
			errorCondition(recall = pairedTTest2, message = gettextRcmdr("You must select two variables."))
			return()
		}
		if (x == y) {
			errorCondition(recall = pairedTTest2, message = gettextRcmdr("Variables must be different."))
			return()
		}
		alternative <- as.character(tclvalue(alternativeVariable))
		level <- tclvalue(confidenceLevel)
		putDialog ("pairedTTest2", list (initial.x = x, initial.y = y, initial.alternative = alternative, 
						initial.confidenceLevel = level))
		closeDialog()
		.activeDataSet <- ActiveDataSet()
                # Added "t.test2 <-"
                doItAndPrint(paste("t.test2 <-t.test(", .activeDataSet, "$", x, 
						", ", .activeDataSet, "$", y, ", alternative='", 
						alternative, "', conf.level=", level, ", paired=TRUE)", 
						sep = ""))
                # Inserted Code:
                doItAndPrint("t.test2")
                doItAndPrint("pairedTTestWords(t.test2)")
                # End Inserted Code
		tkfocus(CommanderWindow())
	}
	OKCancelHelp(helpSubject = "t.test", reset = "pairedTTest2")
	radioButtons(top, name = "alternative", buttons = c("twosided", 
					"less", "greater"), values = c("two.sided", "less", "greater"), 
			labels = gettextRcmdr(c("Two-sided", "Difference < 0", 
							"Difference > 0")), title = gettextRcmdr("Alternative Hypothesis"), 
			initialValue = dialog.values$initial.alternative)
	confidenceFrame <- tkframe(top)
	confidenceLevel <- tclVar(dialog.values$initial.confidenceLevel)
	confidenceField <- ttkentry(confidenceFrame, width = "6", 
			textvariable = confidenceLevel)
	tkgrid(getFrame(xBox), getFrame(yBox), sticky = "nw")
	tkgrid(labelRcmdr(confidenceFrame, text = gettextRcmdr("Confidence Level"), 
					fg = "blue"))
	tkgrid(confidenceField, sticky = "w")
	tkgrid(alternativeFrame, confidenceFrame, sticky = "nw")
	tkgrid(buttonsFrame, columnspan = 2, sticky = "w")
	dialogSuffix(rows = 3, columns = 2)
}

# Interpretation function
independentSamplesTTestWords <- function(x){
    wrapper <- function(text){
        text2 <- strwrap(text)
        for(i in 1:length(text2)){
            cat(text2[i],"\n",sep="")
        }
    }

    varname=strsplit(x$data.name," ")[[1]][1]
    if(x$estimate[1] > x$estimate[2]){
        grp1=strsplit(attr(x$estimate,"names")[1]," ")[[1]][4]
        grp2=strsplit(attr(x$estimate,"names")[2]," ")[[1]][4]
        meangrp1=x$estimate[1]
        meangrp2=x$estimate[2]
    }
    if(x$estimate[1] <= x$estimate[2]){
        grp1=strsplit(attr(x$estimate,"names")[2]," ")[[1]][4]
        grp2=strsplit(attr(x$estimate,"names")[1]," ")[[1]][4]
        meangrp1=x$estimate[2]
        meangrp2=x$estimate[1]
    }
    pval=x$p.value
    alpha <- 1 - attr(x$conf.int,"conf.level")
    t.value=x$statistic
    difference <-abs(x$estimate[1] - x$estimate[2])  
    one.two="one"
    if(x$alternative == "two.sided"){
        one.two="two"
    }

    if(pval < alpha){
        text <- paste("On average, the mean ",varname," for ",grp1, " is about ",
            round(difference,2)," more than the mean ",varname," for ",grp2,
            ". The average ",varname," among ",grp1," was about ",round(meangrp1,2),
            ", and the average ",varname," among ",grp2," was about ",
            round(meangrp2,2),". (t=",round(t.value,3),", p=",round(pval,3),", for a ",one.two,
            "-tailed test). \n \n",sep="")
        wrapper(text)
    }

    else if(pval >= alpha){
        text <- paste("There was no significant difference in the means of ",grp1," and ",grp2,". (alpha=",alpha,", ",one.two,"-tailed test).",sep="")
        wrapper(text)
    }
}


# Modified from independentSamplesTTest from Rcmdr: R Commander
independentSamplesTTest2 <- function () {
	defaults <- list(initial.group = NULL, initial.response = NULL, initial.alternative = "two.sided", 
			initial.confidenceLevel = ".95", initial.variances = "FALSE", initial.label=NULL)
	dialog.values <- getDialog("independentSamplesTTest2", defaults)
	initializeDialog(title = gettextRcmdr("Independent Samples t-Test"))
	variablesFrame <- tkframe(top)
	groupBox <- variableListBox(variablesFrame, TwoLevelFactors(), 
			title = gettextRcmdr("Groups (pick one)"), 
			initialSelection = varPosn(dialog.values$initial.group, "twoLevelFactor"))
	responseBox <- variableListBox(variablesFrame, Numeric(), 
			title = gettextRcmdr("Response Variable (pick one)"),
			initialSelection = varPosn(dialog.values$initial.response, "numeric"))
	onOK <- function() {
		group <- getSelection(groupBox)
		if (length(group) == 0) {
			errorCondition(recall = independentSamplesTTest2, 
					message = gettextRcmdr("You must select a groups variable."))
			return()
		}
		response <- getSelection(responseBox)
		if (length(response) == 0) {
			errorCondition(recall = independentSamplesTTest2, 
					message = gettextRcmdr("You must select a response variable."))
			return()
		}
		alternative <- as.character(tclvalue(alternativeVariable))
		level <- tclvalue(confidenceLevel)
		variances <- as.character(tclvalue(variancesVariable))
		putDialog ("independentSamplesTTest2", list (initial.group = group, initial.response = response, initial.alternative = alternative, 
						initial.confidenceLevel = level, initial.variances = variances, initial.label=.groupsLabel))        
		closeDialog()
                # Added  "t.test3 <-" 
		doItAndPrint(paste("t.test3 <- t.test(", response, "~", group, ", alternative='", 
						alternative, "', conf.level=", level, ", var.equal=", 
						variances, ", data=", ActiveDataSet(), ")", sep = ""))
                # Inserted Code:
                doItAndPrint("t.test3")
                doItAndPrint("independentSamplesTTestWords(t.test3)")
                # End Insertion
		tkfocus(CommanderWindow())
	}
	OKCancelHelp(helpSubject = "t.test", reset = "independentSamplesTTest2")
	optionsFrame <- tkframe(top)
	radioButtons(optionsFrame, name = "alternative", buttons = c("twosided", 
					"less", "greater"), values = c("two.sided", "less", "greater"), 
			labels = gettextRcmdr(c("Two-sided", "Difference < 0", 
							"Difference > 0")), title = gettextRcmdr("Alternative Hypothesis"),
			initialValue = dialog.values$initial.alternative)
	confidenceFrame <- tkframe(optionsFrame)
	confidenceLevel <- tclVar(dialog.values$initial.confidenceLevel)
	confidenceField <- ttkentry(confidenceFrame, width = "6", 
			textvariable = confidenceLevel)
	radioButtons(optionsFrame, name = "variances", buttons = c("yes", 
					"no"), values = c("TRUE", "FALSE"),  
			labels = gettextRcmdr(c("Yes", "No")), title = gettextRcmdr("Assume equal variances?"),
			initialValue = dialog.values$initial.variances)
	tkgrid(getFrame(groupBox), labelRcmdr(variablesFrame, text = "    "), 
			getFrame(responseBox), sticky = "nw")
	tkgrid(variablesFrame, sticky = "nw")
	tkgrid(labelRcmdr(confidenceFrame, text = gettextRcmdr("Confidence Level"), 
					fg = "blue"), sticky = "w")
	tkgrid(confidenceField, sticky = "w")
	groupsLabel(groupsBox = groupBox, initialText=dialog.values$initial.label)
	tkgrid(alternativeFrame, labelRcmdr(optionsFrame, text = "    "), 
			confidenceFrame, labelRcmdr(optionsFrame, text = "    "), 
			variancesFrame, sticky = "nw")
	tkgrid(optionsFrame, sticky = "nw")
	tkgrid(buttonsFrame, sticky = "w")
	dialogSuffix(rows = 4, columns = 1)
} 
