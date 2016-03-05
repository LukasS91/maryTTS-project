#Creating a list of the TextGrids at first
x = 1
strings = Create Strings as file list... list TextGrid/*.TextGrid
numberOfFiles = Get number of strings

#Iterating over the TextGrids
for ifile to numberOfFiles
    	selectObject: strings
    	fileName$ = Get string... ifile
	z = 1
	
	#Load the TextGrids to work on them
    	Read from file... TextGrid/'fileName$'
	s$ = "TextGrid " +replace$(fileName$,".TextGrid","",0)
	selectObject: s$

	#Insert the new interval tier into the TextGrid for labeling the phones
	Insert interval tier... 1 phone
	sentences = Get number of intervals... 2

	#Iterating over intervals from the sentence tier
	for d from 1 to sentences
		label$ = Get label of interval... 2 d

		#Check if there is a sentence label between the boundaries
		if label$ <> ""		

			#If yes, get the offset of the sentence from the sentence tier and insert a boundary on the phone tier
			offset = Get start point... 2 d
			Insert boundary... 1 offset

			#Load the lab file for the related sentence file
			right_labName$ = right$(label$,7)
			if startsWith(right_labName$, "-")
				labName$ = left$(replace$(replace$(label$,".wav",".lab",0),"-","_",0),9)+"0"+right$(replace$(replace$(label$,".wav",".lab",0),"-","_",0),6)
			else
				labName$ = left$(replace$(replace$(label$,".wav",".lab",0),"-","_",0),9)+"1"+right$(replace$(replace$(label$,".wav",".lab",0),"-","_",0),6)
			endif
			Read IntervalTier from Xwaves... 'labName$'

			#Turn the lab file into a TextGrid and shift starting time of this TextGrid to the offset of the sentence
			p$ = "IntervalTier "+replace$(labName$,".lab","",0)
			selectObject: p$
			ptg = Into TextGrid
			selectObject: ptg
			Shift times to... "start time" offset

			#Iterate over the number of intervals from the lab file and set boundaries at the end time of 
			#each label on the phone tier and label these intervals as well 
			int = Get number of intervals... 1
			for k from 1 to 'int'
				selectObject: ptg
				label$ = Get label of interval... 1 'k'
				end_phon = Get end point... 1 'k'
				selectObject: s$
				Insert boundary... 1 end_phon
				z += 1
				Set interval text... 1 'z' 'label$'
			endfor
		endif
	selectObject: s$
	z = Get number of intervals... 1 
	endfor
	Save as chronological text file... Chapter_phon'x'.TextGrid

	#Create lab file
	selectObject: s$
	Extract tier... 1
	new_lab$ = "IntervalTier phone"
	selectObject: new_lab$
	tba = Into TextGrid
	selectObject: tba 
	num = Get number of intervals... 1

	#delete intervals with no label and merge intervals with pauses
	label RESTART
	for p from 1 to num
		selectObject: tba
		label$ = Get label of interval... 1 p
		prev_label$ = ""
		next_label$ = ""
		if p > 1
			c = p -1
			prev_label$ = Get label of interval... 1 c
		endif
		d = p+1
		next_label$ = Get label of interval... 1 d
		if label$ = ""
			if p = 1
				end = Get end point... 1 p
				Remove boundary at time... 1 end
				num -= 1
				goto RESTART
			else
				n = p-1
				if p = num
					start = Get start point... 1 p
					Remove boundary at time... 1 start
					num -= 1
					goto RESTART
				elsif prev_label$ = "_"
					Set interval text... 1 n
				endif
				start = Get start point... 1 p
				end = Get end point... 1 p
				Remove boundary at time... 1 start
				if next_label$ = "_"
					Remove boundary at time... 1 end
				elsif next_label$ = ""
					Remove boundary at time... 1 end
				endif
				num -= 2
				goto RESTART
			endif
		elsif label$ = "_"
			n = p-1
			if prev_label$ = "_"
				Set interval text... 1 n
				start = Get start point... 1 p
				Remove boundary at time... 1 start
				num -= 1
				goto RESTART
			endif
		endif
	endfor
	selectObject: tba
	d = Extract tier... 1
	Save as Xwaves label file... Chapter'x'.lab
	Remove
	x += 1
endfor
