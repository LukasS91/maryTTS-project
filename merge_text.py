import glob
import re

numbers = re.compile(r'(\d+)')
def numericalSort(value):
    parts = numbers.split(value)
    parts[1::2] = map(int, parts[1::2])
    return parts

x = 49
for y in range(x):
    z = y+1
    if z<10 :
        read_files = sorted(glob.glob("CA_BB_0"+str(z)+"*.txt"), key=numericalSort)
    else:
        read_files = sorted(glob.glob("CA_BB_"+str(z)+"*.txt"), key=numericalSort)
    with open("Chapter"+str(z)+".txt","w") as outcome:
        for file in read_files:
            with open(file,"r") as income:
                outcome.write(income.read()+" ")
