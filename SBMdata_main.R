# SBMdata_main.R
# Processes .csv data available at the USB output of the Schneider Battery Monitor

# Tested with output from Battery Monitor Firmware version: 1.01.00 BN100


#--ADMIN

# clean out environment
source ( "SBMdata_clean.R" )

# libraries used in analysis
suppressMessages ( library ( "ggplot2"    , lib.loc=.libPaths() ) )      # ggplot
#suppressMessages ( library ( "scales"     , lib.loc=.libPaths() ) )      # scale_x 
#suppressMessages ( library ( "reshape2"    , lib.loc=.libPaths() ) )      # melt
#suppressMessages ( library ( "data.table"  , lib.loc=.libPaths() ) )      # setorder -- used in GDP to CO2, but put here so doesn't mask other functions
#suppressMessages ( library ( "openxlsx"    , lib.loc=.libPaths() ) )      # worksheet functions
#suppressMessages ( library ( "DataCombine" , lib.loc=.libPaths() ) )      # FindReplace

#set system location and minimum data points required for a daily file
sysloc      <- "Thailand/MaeWei/SewingWorkingshop"
mindaypnts  <- 5     

#--end ADMIN


#--HACK 

# access data log directory and read al file names of type "yyyymmdd.csv"
files               <- list.files ( path = "../1.source/DataLog" , pattern = "\\d{8}\\.csv" , all.files = FALSE,
                            full.names = TRUE , recursive = TRUE , ignore.case = FALSE , 
                            include.dirs = FALSE , no.. = FALSE ) 

# remove any file in which less than five (or your choice - at every five minutes there are 287 data points per day) data points were taken
nrows               <- sapply ( files , function (f) nrow ( read.csv ( f ) ) )
files               <- files[-c( which ( nrows < mindaypnts ) )]

# read in each csv file from list to a single data frame
SBM                 <- do.call ( rbind , 
                                 lapply ( files , function (i) 
                                   { read.csv ( i , header = TRUE , stringsAsFactors = FALSE , 
                                                check.names = FALSE ) } ) ) 

# adjust header names
names (SBM)         <- gsub ( x = names ( SBM ) , pattern = " ", replacement = "")
names (SBM)         <- gsub ( x = names ( SBM ) , pattern = "\\[", replacement = "_")
names (SBM)         <- gsub ( x = names ( SBM ) , pattern = "\\]", replacement = "")
names (SBM)         <- gsub ( x = names ( SBM ) , pattern = "\\%", replacement = "percent")
names (SBM)         <- tolower ( names ( SBM ) )

# parse time column into Date and time columns
# list of tz timezones - https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
SBM$dtime           <- as.POSIXlt ( SBM$time )
SBM$location        <- sysloc
  
#--end HACK


#--PLOTS
ggplot ( data = SBM , aes ( x = dtime , y = temp_c ) ) +
           geom_line ( ) +
#           scale_x_datetime (  ) +
           theme_bw ( )  +
           ggtitle ( "Mae Wei Workshop Solar PV system " ) +
           xlab ( "2018") +
           ylab ( "Battery temperature (degrees C)" )

#--end PLOTS

#--HOUSEKEEPING

# remove temporary variables
rm ( files , nrows , sysloc , mindaypnts )

#--end HOUSEKEEPING