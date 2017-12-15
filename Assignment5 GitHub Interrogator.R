#install.packages("jsonlite")
library(jsonlite)

#install.packages("httpuv")
library(httpuv)

#install.packages("httr")
library(httr)

#install.packages("plotly")
library(plotly)

library(stringr)


oauth_endpoints("github")

myapp = oauth_app(appname = "sharkeyb_GitHub",
                  key = "61d84dc7a6f6f4eedc89",
                  secret = "01a87bba8f3b3bd6078acec95ee2b7425f62a5d5")

github_token = oauth2.0_token(oauth_endpoints("github"), myapp)

gtoken = config(token = github_token)

userNames = c()
createDate = c()
lastUpdateDate = c()


startProfile = content(GET("https://api.github.com/users/dowlind1", gtoken))
startFollowers = content(GET("https://api.github.com/users/dowlind1/followers", gtoken))
startProfileR = jsonlite::fromJSON(jsonlite::toJSON(startProfile))
startFollowersR = jsonlite::fromJSON(jsonlite::toJSON(startFollowers))
userNames = c(startFollowersR$login)
create = startProfileR$created_at
lastUpdated = startProfile_R$updated_at

for(i in 1:length(userNames)){
  
  onceRemovedFollowers = content(GET(paste0("https://api.github.com/users/",userNames[i],"/followers"), gtoken))
  onceRemovedFollowersR = jsonlite::fromJSON(jsonlite::toJSON(onceRemovedFollowers))
  userNames = c(userNames, onceRemovedFollowersR$login)
}

userNames = c(unique(userNames))

for(i in 1:length(userNames)){
  
  twiceRemovedFollowers = content(GET(paste0("https://api.github.com/users/",userNames[i],"/followers"), gtoken))
  twiceRemovedFollowersR = jsonlite::fromJSON(jsonlite::toJSON(twiceRemovedFollowers))
  userNames = c(userNames, twiceRemovedFollowersR$login)
}

userNames = c(unique(userNames))

for(i in 1:length(userNames)){
  
  thriceRemovedFollowers = content(GET(paste0("https://api.github.com/users/",userNames[i],"/followers"), gtoken))
  thriceRemovedFollowersR = jsonlite::fromJSON(jsonlite::toJSON(thriceRemovedFollowers))
  userNames = c(userNames, thriceRemovedFollowersR$login)
}

userNames = c(unique(userNames))

for(i in 1:length(userNames)){
  
  Profiles = content(GET(paste0("https://api.github.com/users/",userNames[i]), gtoken))
  ProfilesR = jsonlite::fromJSON(jsonlite::toJSON(Profiles))
  createDate = c(createDate, ProfilesR$created_at)
  lastUpdateDate = c(lastUpdateDate, ProfilesR$updated_at)
}

dates = data.frame(createDate, lastUpdateDate)

dates$createDate = str_sub(dates$createDate, 1, str_length(dates$createDate)-10)
dates$lastUpdateDate = str_sub(dates$lastUpdateDate, 1, str_length(dates$lastUpdateDate)-10)

dates$createDate = as.Date(dates$createDate, format="%Y-%m-%d")
dates$lastUpdateDate = as.Date(dates$lastUpdateDate, format="%Y-%m-%d")


p = plot_ly(data = dates, x = dates$createDate, y = dates$lastUpdateDate, type = "scatter", mode="markers",
             marker = list(size = 10,
                           color = 'rgba(255, 182, 193, .9)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 2))) %>%
  layout(title = "Created Date vs Last Updated Date",
         yaxis = list(title = 'Last Updated Date', showticklabels = TRUE), 
         xaxis = list(title = 'Create Date', showticklabels = TRUE))

p
