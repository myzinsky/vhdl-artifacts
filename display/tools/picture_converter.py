#!/usr/bin/python

def print_matrix(M):
    for y in range(len(M)):
        for x in range(len(M[0])):
            print(M[y][x], end='')
        print("")

# READ IMAGE:
f=open("bitmap.txt", "r")

w=128
h=64

M = [[0 for x in range(w)] for y in range(h)]

x = 0;
y = 0;

for line in f:
    for symbol in line:
        if (symbol != "\n") :
            M[y][x] = symbol
            x+=1
    x=0
    y+=1

#print_matrix(M)

# Convert Image:

for b in range(8):
    for x in range(128):
        print("\"{}{}{}{}{}{}{}{}\",".format(
            M[8*b+7][x],
            M[8*b+6][x],
            M[8*b+5][x],
            M[8*b+4][x],
            M[8*b+3][x],
            M[8*b+2][x],
            M[8*b+1][x],
            M[8*b+0][x]
        ))

