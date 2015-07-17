library(yaml)
library(github)
library(jsonlite)

create.github.context(personal_token = Sys.getenv("GITHUB_TOKEN"))

yml <- yaml.load_file("_config.yml")

lapply(yml$widgets, function(wdgt) {
  # this returns paginated results - so it's capped at 30...
  a <- get.stargazers(wdgt$ghuser, wdgt$ghrepo)
  length(a$content)
  # other meta data...
})

