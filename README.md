htmlwidgets gallery
===================

This repository serves the [htmwidgets gallery](http://hafen.github.io/htmlwidgetsgallery/).  It is currently in staging.

## Adding a widget

If you are a widget author, you can register your widget by simply providing a thumbnail and adding an entry in the `_config.yml` file of this repository with the meta data for your widget.  To ensure the quality of widgets added to the registry and consistency in how they are displayed, you should expect some amount of discussion during your pull request.

Thumbnails are 350x300 and should look good on a retina screen.

Meta data requirements:

- `name`: the actual name of the R package (required)
- `thumbnail`: location of the thumbnail (required, standard is `images/ghuser-ghrepo.png`)
- `url`: url to the desired landing page you'd like people to first see for the widget (the widget's home page, a vignette, or as a final resort, if not specified, the widget's github page)
- `jslibs`: a comma separated list of javascript library names that the widget depends on, with markdown links to the home pages of the libraries
- `ghuser`: the github user/org where the github repository for the widget resides (required)
- `ghrepo`: the github repository name where the widget resides (required)
- `stars`: the number of github stars (need to move away from hard coding this)
- `tags`: comma separated list (with no spaces) of tags that describe the widget
- `cran_url`: if on cran, the cran url
- `release`: this came from the previous yaml - stable/alpha
- `examples`: url or list of urls of examples (blog posts, gists, vignettes)
- `ghauthor`: the github handle for the primary author of the widget
- `short`: a short (preferably one sentence) description of the package that will be displayed in limited space under the widget thumbnail in the gallery - ideally should be more than "An htmlwidget interface to library x" as that is obvious from jslib, etc. - instead, should describe what you can do with the widget using library x
- `description`: a longer form description

