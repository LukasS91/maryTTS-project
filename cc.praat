#At first, the chapters will be read in
x = 0
strings = Create Strings as file list... list Black*.wav
numberOfFiles = Get number of strings

#The praat script iterates over the chapters
for ifile to numberOfFiles
    	x += 1
	if x < 10
		z$ = "0'x'"
	else
		z$ = "'x'"
	endif
	y = 2
    	selectObject: strings
    	fileName$ = Get string... ifile
	
	#The script loads the chapters and creates TextGrids
    	Read from file... Chapters/'fileName$'
    	textgrid = To TextGrid... Chapter
	sentences = Create Strings as file list... list CA-BB-'z$'-*.wav
	numberOfSentences = Get number of strings

	#After reading in the script iterates over the sentences
	for isentence to numberOfSentences
		selectObject: sentences
		sentenceName$ = Get string... isentence
		Read from file... Chapter'x'/'sentenceName$'
		
		#Cross-correlation between the sentence and the chapter
		s$ = "Sound "+replace$(sentenceName$,".wav","",0)
		c$ = "Sound "+replace$(replace$(fileName$," ","_",0),".wav","",0)
		selectObject: s$
		plusObject: c$
		cc = Cross-correlate... "peak 0.99" zero
		selectObject: cc

		#Get the offset and the end time for the sentence in the chapter
		offset = Get time of maximum... 0 0 None
		offset *= -1
		Remove
		selectObject: s$
		total = Get total duration
		end = offset + total
		selectObject: textgrid

		#Insert boundaries for the sentence into the TextGrid of the chapter
		Insert boundary... 1 offset
		Insert boundary... 1 end
		Set interval text... 1 'y' 'sentenceName$'
		y += 2
	endfor

	#Discard chapter 24 due to problems in the phone labeling of another script
	if x <> 24
		Save as chronological text file... TextGrid/Chapter_'x'.TextGrid
	endif
	Remove
	echo 'x'
endfor