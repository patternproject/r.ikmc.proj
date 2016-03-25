# Note adding four # at the end of comment turns it into a foldable section

## loading libraries ####
library(dplyr)
install.packages("rvest")
library(rvest)
library(stringr)

## setting up the url ####
url = "http://ikmc.kangaroo.org.pk/global-statistics.html"
css = "#DivData td , strong"
css.country = "td:nth-child(1) strong" # only the country names
# testing valid url
browseURL(url)

## reading in the data ####
# reading the url html
page <- read_html(url)

## country list ####
raw.country <- page %>%
  html_nodes(css.country) %>%
  html_text(trim = TRUE) %>%
  unlist()

# except the top heading "Country" all the rest are valid entries
raw.country <- raw.country[-1];       # without 1st element which is simply "Country" 

# total count of countries, there is no repitition here
total.rows = length(raw.country) 

## years list ####
# no of years, goes from 1994 to 2014
total.columns = 2014- 1994 + 1

## all data read in ####
# the complete data matrix
raw.data <- page %>%
  html_nodes(css) %>%
  html_text(trim = TRUE) # %>%
  #str_replace_all("[^[:digit:]]","") # removing extra text

data.1 <- unlist(raw.data)

## generic analysis ####
# returns the first location of 'b', in this case: 2
# # match('b',v)
first.country.start = match(raw.country[1],data.1)
first.country.end = match(raw.country[2],data.1)
i.temp = seq(1,first.country.start-1) #not to miss the double "armenia"
value.data <- raw.data[-i.temp]

# always have 20 values per country 
mydf <- data.frame(matrix(value.data, nrow=total.rows, ncol=23, byrow=TRUE))

# subset to remove the 1st column
my.df = mydf[-1]

# setting the names
df.names = as.character(seq(2014,1994))
df.names = c("Country",df.names)
names(my.df) = df.names
