#search geographic twitter data for Hurricane Dorian, by Joseph Holler, 2019
#to search, you first need a twitter API token: https://rtweet.info/articles/auth.html 

#install package for twitter and initialize the library
install.packages("rtweet")
library(rtweet)
library(igraph)
library(dplyr)
library(tidytext)
library(tm)
library(tidyr)
library(ggraph)
library(tidycensus)
library(ggplot2)
library(RPostgres)
library(RColorBrewer)
library(DBI)
library(rccmisc)


############# SEARCH TWITTER API ############# 

#set up twitter API information
#this should launch a web browser and ask you to log in to twitter
#replace app, consumer_key, and consumer_secret data with your own developer acct info
twitter_token <- create_token(
  app = "yourapp",  					#replace yourapp with your app name
  consumer_key = "yourkey",  		#replace yourkey with your consumer key
  consumer_secret = "yoursecret",  #replace yoursecret with your consumer secret
  access_token = NULL,
  access_secret = NULL
)

#get tweets for hurricane Dorian, searched on September 11, 2019
dorian <- search_tweets("dorian OR hurricane OR sharpiegate", n=200000, include_rts=FALSE, token=twitter_token, geocode="32,-78,1000mi", retryonratelimit=TRUE)


#get tweets without any text filter for the same geographic region in November, searched on November 19, 2019
#the query searches for all verified or unverified tweets, so essentially everything
november <- search_tweets("-filter:verified OR filter:verified", n=200000, include_rts=FALSE, token=twitter_token, geocode="32,-78,1000mi", retryonratelimit=TRUE)

############# FIND ONLY PRECISE GEOGRAPHIES ############# 

#convert GPS coordinates into lat and lng columns
dorian <- lat_lng(dorian,coords=c("coords_coords"))
november <- lat_lng(november,coords=c("coords_coords"))

#select any tweets with lat and lng columns (from GPS) or designated place types of your choosing
dorian <- subset(dorian, place_type == 'city'| place_type == 'neighborhood'| place_type == 'poi' | !is.na(lat))
november <- subset(november, place_type == 'city'| place_type == 'neighborhood'| place_type == 'poi' | !is.na(lat))

#convert bounding boxes into centroids for lat and lng columns
dorian <- lat_lng(dorian,coords=c("bbox_coords"))
november <- lat_lng(november,coords=c("bbox_coords"))

## Making a copy of data (never manipulate the original data in case we make a mistake!!)
november.two <- november
dorian.two <- dorian

## Extracting columns 1 and 2, which contain the uesr_ids and status_ids
user.november <- november.two[,1:2]
user.dorian <- dorian.two[,1:2]

## Saving the CSV file to computer, so I can upload data to my Github
write.csv(user.november, 'november.csv')
write.csv(user.dorian, 'dorian.csv')


############# TEXT / CONTEXTUAL ANALYSIS - HURRICANE DORIAN ############# 

dorian$text <- plain_tweets(dorian$text)

dorianText <- select(dorian ,text)
dorianWords <- unnest_tokens(dorianText, word, text)

# how many words do you have including the stop words?
count(dorianWords)

#create list of stop words (useless words) and add "t.co" twitter links to the list
data("stop_words")
stop_words <- stop_words %>% add_row(word="t.co",lexicon = "SMART")

dorianWords <- dorianWords %>%
  anti_join(stop_words) 

# how many words after removing the stop words?
count(dorianWords)

dorianWords %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique Words",
       title = "Count of unique words found in tweets related to Hurricane Dorian")+
  theme_classic()

dorianWordPairs <- dorian %>% select(text) %>%
  mutate(text = removeWords(text, stop_words$word)) %>%
  unnest_tokens(paired_words, text, token = "ngrams", n = 2)

dorianWordPairs <- separate(dorianWordPairs, paired_words, c("word1", "word2"),sep=" ")
dorianWordPairs <- dorianWordPairs %>% count(word1, word2, sort=TRUE)

#graph a word cloud with space indicating association. you may change the filter to filter more or less than pairs with 10 instances
dorianWordPairs %>%
  filter(n >= 20) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "darkslategray4", size = 3) +
  geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
  labs(title = "Word Network: Tweets during the 2019 Hurricane Dorian event",
       subtitle = "September 2019 - Text mining twitter data ",
       x = "", y = "") +
  theme_void()


############# TEXT / CONTEXTUAL ANALYSIS NOVEMBER ############# 

november$text <- plain_tweets(november$text)

novemberText <- select(november ,text)
novemberWords <- unnest_tokens(novemberText, word, text)

# how many words do you have including the stop words?
count(novemberWords)

#create list of stop words (useless words) and add "t.co" twitter links to the list
data("stop_words")
stop_words <- stop_words %>% add_row(word="t.co",lexicon = "SMART")

novemberWords <- novemberWords %>%
  anti_join(stop_words) 

# how many words after removing the stop words?
count(novemberWords)

novemberWords %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique Words",
       title = "Count of unique words found in tweets on November 19, 2019")+
  theme_classic()

novemberWordPairs <- november %>% select(text) %>%
  mutate(text = removeWords(text, stop_words$word)) %>%
  unnest_tokens(paired_words, text, token = "ngrams", n = 2)

novemberWordPairs <- separate(novemberWordPairs, paired_words, c("word1", "word2"),sep=" ")
novemberWordPairs <- novemberWordPairs %>% count(word1, word2, sort=TRUE)

#graph a word cloud with space indicating association. you may change the filter to filter more or less than pairs with 10 instances
novemberWordPairs %>%
  filter(n >= 20) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "darkslategray4", size = 3) +
  geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
  labs(title = "Word Network: Tweets from November 19, 2019",
       subtitle = "November 2019 - Text mining twitter data ",
       x = "", y = "") +
  theme_void()

