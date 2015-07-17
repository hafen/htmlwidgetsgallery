library(yaml)
library(github)
library(jsonlite)

create.github.context(personal_token = Sys.getenv("GITHUB_TOKEN"))

yml <- yaml.load_file("_config.yml")

meta <- lapply(yml$widgets, function(wdgt) {
  a <- get.repository(wdgt$ghuser, wdgt$ghrepo)
  a$content[c("stargazers_count", "open_issues_count", "forks_count", "watchers_count")]
})

names(meta) <- sapply(yml$widgets, function(x) paste(x$ghuser, x$ghrepo, sep = "_"))

cat(toJSON(meta, auto_unbox = TRUE), file = "github_meta.json")


