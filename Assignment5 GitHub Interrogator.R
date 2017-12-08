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