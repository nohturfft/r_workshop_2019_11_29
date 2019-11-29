#==============================================================================#
# R PROGRAMMING WORKSHOP - PART 2 ####
#==============================================================================#
# LOADING DATA FROM FILES
# ** reading lines of text
# ** Reading words into a vector
# ** Saving a text vector in a file
# ** Counting elements in a vector
# ** Plotting a word cloud
# ** Exercise
#==============================================================================#

#------------------------------------------------------------------------------#
# General parameters / settings for a script should go at the top: ####
#------------------------------------------------------------------------------#
options(stringsAsFactors = FALSE)

#------------------------------------------------------------------------------#
# Working directory ####
#------------------------------------------------------------------------------#
# ** In RStudio you can set the working directory using the 'Session' menu >
#    'Set working directory'.

# ** The best way of setting the correct working directory is to work with
#    RStudio 'projects' (which is what we are doing for this workshop!):
#    RStudio autmatically sets the working directory to the folder that contains
#    the project file ending in '.Rproj'.
#    Info: https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects

# ** You can also use the 'More' menu in the 'Files' tab of the lower right
#    RStudio pane

# ** Usually you set the working directory programmatically using the 'setwd()'
#    function (the following example code will not work on your screen):
setwd("~/Dropbox/SGUL_Teaching/SGUL_Workshops/2017_Programming_Workshop")

# You can get the current working directory using the getwd() function:
getwd()

# Use list.files() to see the contents of the current working directory:
list.files()

#------------------------------------------------------------------------------#
# Load some packages: ####
#------------------------------------------------------------------------------#
if (!require("base64enc")) install.packages("base64enc")
if (!require("magrittr")) install.packages("magrittr")
if (!require("magrittr")) install.packages("magrittr")

#------------------------------------------------------------------------------#
# Check what packages have been installed: ####
#------------------------------------------------------------------------------#
installed.packages() %>% row.names()


#------------------------------------------------------------------------------#
# Reading data from files using 'readLines()': reading lines of text ####
#------------------------------------------------------------------------------#
# (not used much in Bioinformatics really)

# You can select a file programmatically [e.g. by copying from the console after
# list.files() ]
my.file <- "data/green_eggs_and_ham.txt"
# Or you can choose a file interactively with the 'file.choose()' function
# (please pick 'green_eggs_and_ham.txt' in the data folder):
my.file <- file.choose(new=FALSE)
print(my.file)

# Some useful functions...
basename(my.file)
dirname(my.file)

# Let's start by reading just the first 10 lines from the file (n=10)
txt <- readLines(con=my.file, n=10)
# The results is a text ("character") vector:
txt

# To print the text in the console with linefeeds (newlines) re-inserted,
# use cat(); the 'sep' argument tells R to separate items with newline ("\n)
# characters:
cat(txt, sep="\n")

#------------------------------------------------------------------------------#
# Reading individual words into a vector using the 'scan()' command: ####
#------------------------------------------------------------------------------#
# The approach is useful to load gene symbols!
txt <- scan(file="data/green_eggs_and_ham.txt", what=character())
txt
class(txt)

# The 'length()' command return the number of items in a vector:
length(txt) # 778

# The following command is self-explanatory:
unique(txt)

# Sort alphabetically:
sort(txt)

# Functions can be called inside other functions - "nesting":
length(unique(txt)) # 73

#------------------------------------------------------------------------------#
# magrittr pipes instead of nesting: ####
#------------------------------------------------------------------------------#
# Unix/Linux-like pipes have become more popular -
# the '%>%' command from the R magrittr package sends the result of one command
# on to the next
txt %>% unique
txt %>% unique %>% sort
txt %>% toupper %>% unique %>% sort
txt %>% toupper %>% unique %>% length # 53

# The results of a pipe can of course be stored in a variable:
txt.up <- txt %>% toupper
print(txt.up)
txt.lo <- txt %>% tolower
print(txt.lo)

#------------------------------------------------------------------------------#
# Saving a text vector in a file: ####
#------------------------------------------------------------------------------#
# First check that you are in the right working directory to save the file:
getwd()

# Use setwd() or the RStudio Session menu to change the working directory.
# (Or use the complete file path in the 'file=' argument below)

# The following cat() syntax prints to the console:
cat(txt.up, sep="\n")

# Adding the 'file=' arguments saves the results instead:
cat(txt, sep="\n", file="newfile.txt")

# Check whether the file has really been created:
list.files()

# Clicking on the new file in the 'Files' tab will open it in R for you to
# check.

#------------------------------------------------------------------------------#
# Counting elements in a vector: ####
#------------------------------------------------------------------------------#
# The 'table' function counts how often each element occurs in a vector:
ta <- txt %>% toupper %>% table
ta
class(ta)

# 'as.data.frame' converts the table object to an R data.frame:
# (the dot before the comma refers to the output of the magrittr pipe)
df <- txt %>% toupper %>% table %>% as.data.frame(., stringsAsFactors=FALSE)
# Add more useful column names:
names(df) <- c("word", "count")

# Sort by word count:
df <- df[order(df$count, decreasing=T),]

# Clean up row names:
row.names(df) <- NULL

# Show the 10 most abundant words:
head(df, 10)

# A nicer way to look at data frames:
View(df)

#------------------------------------------------------------------------------#
# Barplots: ####
#------------------------------------------------------------------------------#
barplot(table(txt.lo[1:20]), horiz=TRUE, las=1)

# Most people these days use the ggplot2 package to generate plots in R.
# Just an example - ggplot2 requires an advanced workshop...
if (!require(ggplot2)) install.packages("ggplot2")
ggplot(data=head(df, 10), aes(x=word, y=count)) +
  geom_bar(stat="identity", color="black", fill="lightgreen") +
  coord_flip() +
  labs(
    title="Frequency of some words: GREEN EGGS AND HAM",
    subtitle="by Dr Seuss")

#------------------------------------------------------------------------------#
# Plotting a word cloud: ####
#------------------------------------------------------------------------------#
if (!require(wordcloud2)) install.packages("wordcloud2"); library(wordcloud)
help(wordcloud, package="wordcloud")
set.seed(1234)
wordcloud(words=df$word, freq=df$count)

# Add color
wordcloud(words=df$word, freq=df$count, colors=brewer.pal(8, "Dark2"))

# Play around:
wordcloud(words=df$word, freq=df$count,
          colors=brewer.pal(8, "Dark2"),
          max.words=20)

# Play with colors:
## Check available pallettes from the RColorBrewer package:
display.brewer.all()
set.seed(1)
wordcloud(words=df$word, freq=df$count, colors=brewer.pal(8, "Set1"))
set.seed(42)
wordcloud(words=df$word, freq=df$count, colors=brewer.pal(8, "Set2"))
wordcloud(words=df$word, freq=df$count, colors=brewer.pal(8, "Accent"))


#------------------------------------------------------------------------------#
# Save wordcloud as PDF or PNG or copy to the clipboard: ####
#------------------------------------------------------------------------------#
# Click the "Export" button in the RStudio 'Plots' tab on the bottom right and
# follow the instructions.


#------------------------------------------------------------------------------#
# EXERCISE ####
#------------------------------------------------------------------------------#
# Create a text file with 'file.edit' and analyze your own poem or other text:
file.edit("abc.txt")

# How about e.g. Boris Johnson's first speech as prime minister:
# https://www.gov.uk/government/speeches/boris-johnsons-first-speech-as-prime-minister-24-july-2019

#
