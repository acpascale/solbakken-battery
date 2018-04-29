# solbakken-battery
R code for automated processing of Schneider Battery Monitor data

This code processes data structures downloadable from the front port of Schenider Battery Monitor.

Version 0.1 is designed to:

0.1) In order to use Git on Mac OS High Sierra see: https://apple.stackexchange.com/questions/254380/macos-sierra-invalid-active-developer-path
0.2) Using RStudio with Git: https://cfss.uchicago.edu/git05.html
1) Add all new data to the battery monitor main database
2) Create a basic set of graphics for 
    a) Each day of the previous week
    b) Each month of the past year in which the system was operational
    c) The entire span the system has been operational
3) Save the graphics in a pdf file
