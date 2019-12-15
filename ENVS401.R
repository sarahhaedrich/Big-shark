
library(tidyverse)
library(data.table)
library(tidytext)
library(stringr)
library(dplyr)
library(ngram)

library(tidyverse)
library(data.table)
library(tidytext)
library(stringr)
library(dplyr)
library(ngram)

############################# "Are you concerned about climate change?" WORD COUNT #####################
## Importing the text (copied from the Otter transcripts oneline) and creating character vectors containing the text language

##Chris Runcie 
chris.one <- "Very, very, very concerned. And we have, we have a grandchild and another one on the way. And we think about the future of our children. And we see that changes happening before our eyes around. I mean, so we, you know, we recognize climate change because we lived here in Starksboro for 40 years and we've seen huge changes in the time of year when it gets cold. And, you know, in the earliest frost, and the coldest temperatures and all those things. Today, I think I just told you that we, you know, our road got washed out. We couldn't get to our bridge, and that is the first time we've lived here that anything like that has every happened. Three, three inches of rain in one rainstorm. And we're, you know, this morning we looked at that and we thought, wow, you know, does this mean our house will be cut off from the town? How long can we go on liviing here? Because this is an unusual event and yet they say the hundred year flood is now happening every ten years. So flooding of that river would have a dramatic effect on our ability to get here.And, you know, that's the direct effect. You know... we worry about...We're skiers and we see the ski season shortening, and we see winters being icy, and we now we we buy a new pair of those.. what do you call those spikes that...microspikes! So basically we live in those all winter. Yeah, you know, because the ground was icy now when it used to be either..you know... snow covered. So I see conditions for walking at our age treacherous. So that's a huge change and then you know..that's from our little lives here in Starksboro. But of course we're really concerned about the effect on the whole world, and horrified by the changes. That we are afraid will happen, that we know will happen. So many people displaced by drought. And we have fun. We have two children who live in California. You know, our son is in Davis which is downwind from all the fires around San Fransisco. Sometimes they have to leave town because the air so bad. You know, we worry about having fire because our daughter lives closer down in the valley where it's really hot. So yeah, so we're worried about California burning up. Okay, so for all those reasons. We're worried about the future of the world for people to live in it if we don't pay attention to climate change."
## Sara Burchard
sara.one <- "Well, everything. Yes I'm very concerned. I've been concerned for about 25 years which probably wasn't soon enough. Yeah, I just think we're looking at a major disaster. I mean, there's no way that this is stopping. You know, maybe I mean there's a lot of people doing a lot of exciting and interesting things, it's very hopeful, but to not recognize that, you know, this is a complete world thing, and there are places where there is such heavy population and the land has already been pretty much used up, there's going to be enormous efforts to migrate. And we're already seeing that that's not met with great support or applause, and so there's a real population issue and there's a real migration issue. And a great real feeding issue, in terms of because over history, humanity hasn't appreciated the fact that this is like a terrarium and they, you know, they just cut down all the trees and then, like they're doing in Brazil, I mean, so I'm not exactly what is the word? Feeling good about it or thinking that not to worry about taking care of it and of course in this country I'm just blown away and angry and upset about everything that is being done to set us back. But the good news is ther's a lot of people in a lot of, some states and some you know more proper authorities are trying to and some businesses are finally beginning to see the light that they need to create something that's more reasonable in terms of climate pressures if they want to be in business in 20 years. Is that enough? [Laughs] I mean there's nothing to not worry about.."
## Bruce Catlin
bruce.one = "Yes"
## Kudd
kudd.one = "So the first answer is yes."
## Richard Hotchkins
richard.one <- "Sure, sery much so. I think over time, I probably won't see it, at age 72, but someone your age would certainly see the fact that there would be different trees establishing themselves, different species over the next 50 years or so. That are some of the trees that are there probably won't be able to survive if we have what we're seeing. If that develops, the temperature change would cause other trees to grow there than what are growing there now for instance."
## Bill Jesdale
bill.one <- "Uh, I'm not sure that it has. My concern about climate change is, uh, there's not enough recognition that people, of people understanding that the earth is finite."
## Bruce Bayliss
bruceb.one <- "Yes. Yes, we, so that's why we have installed uh solar backers, you know for electricity for the house, that's why we heat with wood. So yeah"
## Len Schmidt
len.one <- "Yeah, it's very apparent that the climate is very different than from when I was a kid, and it continues to change so very much so"
## Charlotte Sullivan
charlotte.one <- "Yeah, I think big question lots of answers so I'll kind of like pick somewhere and then you can cut me off... no... Yeah climate change makes natural systems very unpredictable. And I think as a, as a farmer or as a steward of land, you're always used to weather being unpredictable, all sorts of unpredictable forces, natural or otherwise, whatever. But I think what, what we're seeing now with climate changes, levels of unpredictability that are unprecedented and feel way larger often than we have the human capacity to fix. I mean, and even something as small as the beaver dam collapse that that happens. That's an uncommon thing. I'm like totally overworrying it but it's also really easy for me to look at that rainstorm and feel like I like...hmmm I've lived in New England for most of my life, when has it rained almost four inches overnight, you know, you can't help but notice these extremities and then the the side effects of them and then how that's going to impact all sorts like set up a chain reaction. So I think that really concerns me. And then just not, you know, I don't you know, after that happened, I was like, should I have gone and like try to stop it from breaking, but it's hard to not it's hard to know, like, what control I can really have or what support I can really offer the natural world outside my door. When all of these things are happening. I think that's a big challenge."
## Timothy Hanson
timothy.one <- "Oh, desperately, yes. Well the consensus is that it's real and although those that are situated in the north east or in the US in general, between our resources and our geography, We will be probably the least likely to be affected by it. Countries like Bangladesh and low lying parts of India and alot of islands in the Pacific will be completely inundated and that will be incredibly destabilizing politically and you think we have problems now, wait until Bangladesh has no where to go and they'll just start coughing up potentially millions of people having to migrate. I mean, it's just, and that's if global warming is incremental and the relatively modest two or three degrees C that they're talking about. If we get some kind of runaway thing that could be the end of you know civilization as we know it. If it runs away and I don't think I'll see that I'm too old I'll be dead before then but my grandkids will see it and you're young and you'll see it and that's the runaway stuff that scares me. I don't, Not a lot of people are saying that's going to happen but they are predicting the, you know the, Two or three meter sea rise and the two or three degree temperature changes will devastate Bangladesh and the Maldives and other countries that are just so low lying and that will be so destabilising politically. And of course, New York City flooded, the subways flooded during the, during Irene, and places in Florida are routinely having hightide floods and you raise the sea level three inches, six inches, New York's gonna be waterlogged and then what do you do when ten or twelve million people and the whole coast of Florida and other places, it will be incredibly disruptive. We in this country, if we pull together as a country have the resources to deal, to adapt but I don't know ,I don't know whether we will or not and then the other thing is so obvious, the tropical diseases that were killed off my good hard frost, are now creeping their way north, causing problems. I think they found a virus in Brakebill I can't remember the name of it but it's something like that and. Things that were not an issue because we were so cold, will be an issue, starting now and will be in the future so, yeah, those are my concerns."


## Pasting the text into one character vector
paste.question.one <- paste(chris.one, sara.one, bruce.one, kudd.one, richard.one, bill.one, bruceb.one, len.one, charlotte.one, timothy.one)

## Creating a data frame
data.question.one <- data.frame(text = paste.question.one,
                                stringsAsFactors = FALSE)

## Removing stop words from text (stop words include words such as "the", "a," "but," etc. )
## Grouping by "word"
## Counting the number in each group
## Arranging the words by count
## Examining the top 25 
word.count.one <- data.question.one %>%
  unnest_tokens("word", "text") %>%
  anti_join(stop_words) %>%
  group_by(word) %>%
  summarize (count = n()) %>%
  arrange(-count)%>%
  head(25)

View(word.count.one)

####################### "Have you experienced extreme weather events? If so, has it changed the way your manage your forest land?" WORD COUNT ########################################################

## Importing the text (copied from the Otter transcripts oneline) and creating character vectors containing the text language

## Chris Runcie
chris.two <- "And, yeah, very much so. Obviously we have a limited supply. We're lucky in Vermont to have pretty good water quality and create a pretty good amount of water. But we know from the condition of Lake Champlain that the story is not all good. And I have been a member of the Lewis Creek Association for many, many years. And I I... every summer I help with the collecting water samples from the Lewis Creek, and they get they get sent to the state lab and analyzed. You know, we know that we have a range of pollutants in our beautiful state. So yeah, I'm concerned about that and the Lake Champlain. And I think there's still...there's still a lot of people in the state government who feel that the fishing industry is really important and for tourism and they make decisions maybe based on that rather than on health. We've discovered that, the mud puppy, a salamander that was present in the Lewis Creek doesn't seem to be there anymore and that they are quite susceptible to the lampricide that they put in, and so the state is pouring lampricide into the tribute, you know, the streams that empty in to Lake Champlain or control the lamprey, which actually native because fishermen don't like to pull out fish that have lampreys on the. Yeah, so there's still a lot going on, even in our very lovely state. Yeah. Yeah. Anyway, so yeah, I know, you know, I know that we need to do more about conserving riparian corridors because that's a really good way of keeping a good and simple way of keeping erosion from happening and keeping, you know, soil and phosphorus out of the rivers. So that's a good step we can all work towards."
## Sara Burchard
sara.two <- "Water quality? Yes, yes that's why I, you know, I'm working to impede the runoff of the mountains. And, and here a few years ago, fortunately, the city sent around with our tax bill. They showed a map of people who were too close to the lake to be using, you know, all these poisons on their lawn, so they have a beautiful green lawn, but that wasn't a problem for me because I've never used any things on it. And also because I don't, you know, as long as things are growing in the lawn I'm not too concerned. And actually, I get, you know, I get a lot of interesting volunteers in my lawn, from the woods.."
## Bruce Catlin
bruce.two <- "Yes."
## Kudd
kudd.two <- "The second part of that question is how does that affect? I'm not sure. My concern is, so there's a larger sugar woods up on the upper part of the land. And I forget did you say you had looked at a map of my land or...Yeah. Okay. So our land kind of runs from a road down the river and goes out very close to a road about three or 400 vertical feet up, about a mile along a wood road to get up there at the top. And at the top is where the sugaring, the majority of the sugaring, has occurred in the past. So in thinking about getting somebody into sugar again or whether I want to try to attempt to tap myself, I haven't, and of course this whole thing about trying to split up the land comes into the middle of it all, but so I am concerned about the investment. Generally, people I believe think that if they're going to set up a sugar woods, it's like an- on the pipeline is good for and I am concerned about what's gonna happen to the sap run now in that 10-year period. And I'm also concerned with the woods there's some nice ash trees and I'm worried about the Emerald bugs getting at them. I haven't quite come to terms with what's gonna, you know what needs to happen about that. Those are the two concerns, I guess, one is bugs and the other's climate."
## Richard Hotchkins
richard.two <- "I don't think it makes a big difference. And you know, I'm very concerned about it just generally but not with respect to the land necessarily. The land will respond as it will respond. There may be certain things that need to be harvested because they're not, they don't do well in that changed environment. Some of those trees may need to be harvested earlier than what we would normally harvest them just to get the value out. And that would allow other trees, whatever would be growing better at that time on that property, to fill in and nature has a way of filling voids and it might cost us to harvest certain species earlier than we would otherwise if they're not gonna be growing well there. We did have a huge event , what they call Tropical Storm Irene. It widened and deepened that stream that runs through that stream rather substantially and that whole Central Valley part of Vermont was impacted very, very drastically by that, that event. It hasn't changed how we manage the property. We're very concerned about harvesting anything within what they call the Riparian zone, in river and stream areas. But it was pretty, pretty evident how catastrophic events are large rain events for instance. They can literally alter landscape."
## Bill Jesdale
bill.two <- "Um, no I can't say that it has."
## Bruce Bayliss
bruceb.two <- "Uh, no. I would say, I mean we've experienced snow storms like everybody else. But no it's not, I haven't done anything in terms of to [inaudible]"
## Len Schmidt
len.two <- "Um, I primarly around umm, becoming more intense and that ahh, you know, maintaining...maintaining forest growth, logging access roads that have, you know are properly cited that have proper drainage devices in place so that the roads don't wash out, you know maintaining enough forest cover that there isn't erosision and that there's enough crown closure so that you know trees are relatively protected from wind events. I think those are probably the primary ways.Um, yeah I mean I think that there have been a number of events  extreme enough to wash out local...local roads and highways. And you think about you know building a road into a forest in order to access timber, and that road is much, you know has to be much less expensive. You can invest the resources to the wood roads that the town and the state invests into roads and highways. So every time there's a, you know a road wash out. I wonder about how roads are doing and I'm really glad and proud that are woods roads are doing really well. A couple years ago, we invested some excavator time in reducing the slope on one of our woods roads because it as climate was changing, it was starting to concern me how steep this particular road was. But in general I feel like our woods roads are performing better than the public roads and highways are, which it seems like they should at least be able to do as good as I can."
## Charlote Sullivan
charlotte.two <- "I mean cold. So really, really cold temperatures. So we have this is not this is like more of an actual agricultural example rather than forestry I guess but the property has a small hoop house on it which is really exciting because that gives us an opportunity to plant some of our own our own greens and try to overwinter some some of those and so when you have an event like we just recently had with the snow and the really deep sudden freeze, it's like that, again, like the amount of time that in past years you maybe would have had to sort of plan and prepare for to grow to growing things through the winter. Yeah, you know, with this recent event like did I have time to like make sure all the water was out of the hose you know, did I have taught me you know, certain things about done but like, not everything did. So, you know, that's another factor."
## David Rose Allen
david.two <- "Yes, Yeah Yeah Yeah, I mean, there was a time when I thought of letting someone harvest some of the trees, but then I decided that I didn't want to do that because i think the trees are good for the environment.No, only, only understand that I do think the times is changing and the fact that I do have trees on my property would make the trees more important."
## Timothy Hanson
timothy.two <- "Well, we don't have a large body of water that goes through our land, we have a small brook and the water runs pretty good but it's nowhere near more than three or four feet across. We don't, it makes me want to, not harvest aggressively, I want to store as much carbon on the land that We have that we can, I'm gonna really, certainly I have no desire to clearcut, or harvest commercially, aggressively, to maximise income, because all that will do is just free up more carbon to be and I feel real bad about burning firewood but we grow more trees than wood we burn. At least I'd like to think that's true. We are aware we have more, this spring was incredibly wet. sure, incredibly wet, and completely changed how we access parts of our land because there is standing water in places i've never seen standing water so we have to re-route our path to access parts of our land because there's standing water in places where I've never seen standing water so we have to re-route our paths to get to certain places. My main issue is extreme events is what everyone else has when roads are washed out or bridges are washed out and that's our fault. "

## Pasting the text into one character vector
paste.question.two <- paste(chris.two, sara.two, bruce.two, kudd.two, richard.two, bill.two, bruceb.two, len.two, charlotte.two, david.two, timothy.two)

## Creating a data frame
data.question.two <- data.frame(text = paste.question.two,
                                stringsAsFactors = FALSE)

## Removing stop words from text (stop words include words such as "the", "a," "but," etc. )
## Grouping by "word"
## Counting the number in each group
## Arranging the words by count
## Examining the top 25 
word.count.two <- data.question.two %>%
  unnest_tokens("word", "text") %>%
  anti_join(stop_words) %>%
  group_by(word) %>%
  summarize (count = n()) %>%
  arrange(-count)%>%
  head(25)



############################ "Are you concerened about water quality?" WORD COUNT ###############################################

## Importing the text (copied from the Otter transcripts oneline) and creating character vectors containing the text language
## Chris Runcie
chris <- "And, yeah, very much so. That's obviously we have a limited supply. We're lucky in Vermont to have pretty good water quality and a pretty good amount of water. But we know from the condition of Lake Champlain that the story is not all good. And I have been a member of the Lewis Creek Association for many, many years. And I I... every summer I help with the collecting water samples from the Lewis Creek, and they get they get sent to the state lab and analyzed. You know, we know that we have a range of pollutants in our beautiful state. So yeah, I'm concerned about that and about the Lake Champlain. And I think there's still...there's still a lot of people in the state government who feel that the fishing industry is really important and for tourism and they make decisions maybe based on that rather than on health. We've discovered that the mud puppy, a salamander that was present in the Lewis Creek, doesn't seem to be there anymore and that they are quite susceptible to the lampricide that they put in, and so the state is still pouring lampricide into the tribute, you know, the streams that empty into Lake Champlain in order to control the lamprey, which is actually native because fishermen don't like to pull out fish that have lampreys on them. Yeah, so there's still a lot going on, even in our very lovely state, that probably shouldn't happen. Anyway, so yeah, I know, you know, I know that we need to do more about conserving riparian corridors because that's a really good way of keeping, a good and simple way of keeping erosion from happening and keeping, you know, soil and phosphorus out of the rivers. So that's a good step we can all work towards."
## Bruce Runcie
bruce <- "Yes."
## Linda Johnson
linda <- "Do I do but I'm, as I said, I'm embarrassed because if these people, Monument farms were into no till and crop rotation and not having big machines on the land, I mean, that's the embarrassing thing. I know that I know that the things that are wrong and I know Fukuoka, you must have heard him the Japanese man from many, many years ago who kind of he wrote the last the one strong revolution. And that was when he was the first guy to tell us about this no tilling, but it's the way he does it is very complicated. But if I were young, I had wanted to be a farmer. I took agricultural classes in one year in college that I went to. Yeah, so I feel I feel really guilty that I didn't do anything to protect the water that could be running off from that land. And it's nice to have someone to admit it to. My friends don't seem to care."
## Kudd
kudd <- "I mean, personally no, because where we are not a lot happens to it. But in general, yes. I want, you know, I don't want to be sending a bunch of silt and erosion out into the river. So we've got a brook that comes pretty much through the length of our land that dumps right into the New Haven river."
## Sara Burchard
sara <- "Water quality? Yes, yes that's why I, you know, I'm working to impede the runoff of the mountains. And, and here a few years ago, fortunately, the city sent around with our tax bill. They showed a map of people who were too close to the lake to be using, you know, all these poisons on their lawn, so they have a beautiful green lawn, but that wasn't a problem for me because I've never used any things on it. And also because I don't, you know, as long as things are growing in the lawn I'm not too concerned. And actually, I get, you know, I get a lot of interesting volunteers in my lawn, from the woods."
## Richard Hotchkins
richard <- "Yeah. Water quality's real important And what happens is if you fell too many trees you allow too much run off and you degrade the streams rather significantly. And so it's really important not to harvest close the streams. Our forester recommends leaving at least 100 foot of No, you know, no harvest in that area 100 feet on either side of the stream. And so getting that that just will be a wilderness area basically in that in that riparian area."
## Bill Jesdale
bill <- "Not very.Yeah we've got some, some erosion that we need to deal with. And the problem is getting to the area where there needs to be some erosion control, uh, requires getting through this wet area. So it's a little bit of a compound problem."
## Bruce Bayliss
bruce.bayliss <- "Yes, and that's why I would like to do some work on the property to prevent runoff. Last year we did put in probably close to 40 water bars across some of the trails."
## Charlotte Sullivan
charlotte <- "I am concerned about water quality. I mean, what we need water, human save water, clean water, the water delay. For me. Water is as important as protecting pollinators so we can still have our food still have food, right? So in this, so if we're not thinking systematically about actions that we need to take, whether as landowners or citizens we're not going to have, we're not going to be able to enjoy the benefit of staying healthy and alive. So You know, one of the coolest not to bring it all the way back to beavers. But since we found I've been like obsessed beavers and I learned that beavers really matter for water quality for example and so you know another little piece of the heartbreak was like no like these beavers are awesome I want them here like they're gonna help like filter water and with all the other water systems that like their one little colony is a part of I think I'm just able to now being where I am like think even more holistically about water systems."
## Len Schmidt
len <- "Yeah, I think that's the primary impact I see, where I think about with you know, with actively managing forest, just the fact that you have a forest is you know, going to have a beneficial impact on the quality of you know, water. But managing for those..those high rain and high flood events is also I think really important. But yeah, I mean the forest...I know what David Bramet from Vermont Family Forests likes to preach the most important forest product in Vermont is high quality water, but landowners don't really get credit or benefit from the high quality water that they produce."
## David Rose Allen
david <- "Yeah, I have a well, two wells, three wells from the property and the water that I drink comes directly from the well, and it doesn't need to be attributed in any way I have a simple whole house filter and the water is very good quality."
## Timothy Hanson
timothy <- "Well, I think I talked about that in the beginning but indirectly... You know, when we talk about water bars and other things, keping away from the brook when we do our work, trying not to disturb the natural flow of water or to divert it when we do disturb it so that water can't get upstream and cause damage. Yes, we are, we are concerned and to that extent, we try not to land open. We try to cover things with hay or whatever... (inaudible)."

## Pasting the text into one character vector
paste.question.three <- paste(chris, bruce, linda, kudd, sara, richard, bill, bruce.bayliss, charlotte, len, david, timothy)


## Creating a data frame
data.question.three <- data.frame(text = paste.question.three,
                                stringsAsFactors = FALSE)

## Removing stop words from text (stop words include words such as "the", "a," "but," etc. )
## Grouping by "word"
## Counting the number in each group
## Arranging the words by count
## Examining the top 25 
word.count.three <- data.question.three %>%
  unnest_tokens("word", "text") %>%
  anti_join(stop_words) %>%
  group_by(word) %>%
  summarize (count = n()) %>%
  arrange(-count)%>%
  head(25)

View(word.count.three)







