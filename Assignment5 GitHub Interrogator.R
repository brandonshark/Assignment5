#install.packages("jsonlite")
library(jsonlite)

#install.packages("httpuv")
library(httpuv)

#install.packages("httr")
library(httr)

oauth_endpoints("github")

myapp = oauth_app(appname = "sharkeyb_GitHub",
                   key = "61d84dc7a6f6f4eedc89",
                   secret = "01a87bba8f3b3bd6078acec95ee2b7425f62a5d5")

github_token = oauth2.0_token(oauth_endpoints("github"), myapp)

gtoken = config(token = github_token)

req = GET("https://api.github.com/users/jtleek/repos", gtoken)

stop_for_status(req)

json1 = content(req)

gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"]

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
  
  nextFollowers = content(GET(paste0("https://api.github.com/users/",userNames[i],"/followers"), gtoken))
  nextFollowersR = jsonlite::fromJSON(jsonlite::toJSON(nextFollowers))
  userNames = c(userNames, nextFollowersR$login)
}

