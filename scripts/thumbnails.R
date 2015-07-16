## install packages
##---------------------------------------------------------

library(yaml)
yml <- yaml.load_file("_config.yml")

strings <- sapply(yml$widgets, function(x)
  paste0(x$ghuser, "/", x$ghrepo))

# urls <- paste0("https://github.com/", strings)
# system2("open", urls)

for(strng in strings) {
  message(strng)
  suppressMessages(devtools::install_github(strng))
}


## make an example for each package
##---------------------------------------------------------

pkgstrings <- sapply(yml$widgets, function(x) x$name)
# cat(paste0("library(", pkgstrings, ")", collapse = "\n"))

thumbs <- sapply(yml$widgets, function(x)
  paste0("images/", x$ghuser, "-", x$ghrepo, ".png"))
names(thumbs) <- pkgstrings

ww <- 350*2
hh <- 300*2

help.start()

library(trelliscope)

library(datamaps)
p <- datamaps(width = ww, height = hh)
widgetThumbnail(p, thumbs["datamaps"])

library(rChartsCalmap)
dat <- read.csv('http://t.co/mN2RgcyQFc')[,c('date', 'pts')]
p <- calheatmap(x = 'date', y = 'pts',
  data = dat,
  domain = 'month',
  start = "2012-10-27",
  legend = seq(10, 50, 10),
  itemName = 'point',
  range = 7,
  width = ww, height = hh
)
# widgetThumbnail(p, thumbs["rChartsCalmap"])
# do this one manually...
p

library(leaflet)
content <- paste(sep = "<br/>",
  "<b><a href='http://www.samurainoodle.com'>Samurai Noodle</a></b>",
  "606 5th Ave. S",
  "Seattle, WA 98138"
)
p <- leaflet(width = ww, height = hh) %>% addTiles() %>%
  addPopups(-122.327298, 47.597131, content,
    options = popupOptions(closeButton = FALSE)
)
widgetThumbnail(p, thumbs["leaflet"])

library(DT)
p <- datatable(iris, width = ww)
widgetThumbnail(p, thumbs["DT"])

library(dygraphs)
p <- dygraph(nhtemp, main = "New Haven Temperatures", width = ww, height = hh) %>%
  dyAxis("y", label = "Temp (F)", valueRange = c(40, 60)) %>%
  dyOptions(fillGraph = TRUE, drawGrid = FALSE) %>%
  dyRangeSelector()
widgetThumbnail(p, thumbs["dygraphs"])

library(metricsgraphics)
library(RColorBrewer)
p <- mjs_plot(movies$rating, width = ww, height = hh) %>% mjs_histogram(bins=30)
widgetThumbnail(p, thumbs["metricsgraphics"])

library(streamgraph)
library(dplyr)
ggplot2::movies %>%
  select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  tidyr::gather(genre, value, -year) %>%
  group_by(year, genre) %>%
  tally(wt=value) -> dat
p <- streamgraph(dat, "genre", "n", "year", interactive=TRUE, width = ww, height = hh) %>%
  sg_axis_x(20, "year", "%Y") %>%
  sg_fill_brewer("PuOr")
widgetThumbnail(p, thumbs["streamgraph"])

library(networkD3)
# data(MisLinks)
# data(MisNodes)
# forceNetwork(Links = MisLinks, Nodes = MisNodes, Source = "source",
#   Target = "target", Value = "value", NodeID = "name",
#   Group = "group", opacity = 0.4,
#   colourScale = "d3.scale.category20b()")
library(RCurl)
URL <- "https://raw.githubusercontent.com/christophergandrud/networkD3/master/JSONdata/energy.json"
Energy <- getURL(URL, ssl.verifypeer = FALSE)
EngLinks <- JSONtoDF(jsonStr = Energy, array = "links")
EngNodes <- JSONtoDF(jsonStr = Energy, array = "nodes")
p <- sankeyNetwork(Links = EngLinks, Nodes = EngNodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  fontSize = 12, nodeWidth = 30, width = ww, height = hh)
widgetThumbnail(p, thumbs["networkD3"])

library(threejs)
N     = 20000
theta = runif(N)*2*pi
phi   = runif(N)*2*pi
R     = 1.5
r     = 1.0
x = (R + r*cos(theta))*cos(phi)
y = (R + r*cos(theta))*sin(phi)
z = r*sin(theta)
d = 6
h = 6
t = 2*runif(N) - 1
w = t^2*sqrt(1-t^2)
x1 = d*cos(theta)*sin(phi)*w
y1 = d*sin(theta)*sin(phi)*w
i = order(phi)
j = order(t)
col = c( rainbow(length(phi))[order(i)],
         rainbow(length(t),start=0, end=2/6)[order(j)])
M = cbind(x=c(x,x1),y=c(y,y1),z=c(z,h*t))
p <- scatterplot3js(M,size=0.25,color=col,bg="black", width = ww, height = hh)
# widgetThumbnail(p, thumbs["threejs"])
# unsuccessfull... do it manually
p

library(DiagrammeR)
p <- grViz("
digraph neato {

node [shape = circle,
      style = filled,
      color = grey,
      label = '']

node [fillcolor = red]
a

node [fillcolor = green]
b c d

node [fillcolor = orange]

edge [color = grey]
a -> {b c d}
b -> {e f g h i j}
c -> {k l m n o p}
d -> {q r s t u v}
}",
engine = "neato", width = ww, height = hh)
widgetThumbnail(p, thumbs["DiagrammeR"])

library(sigmaGraph)
# no examples found...

library(bubbleCloud)
# no examples found

library(d3plus)
# edges <- read.csv(system.file("data/edges.csv", package = "d3plus"))
# nodes <- read.csv(system.file("data/nodes.csv", package = "d3plus"))
# p <- d3plus("rings",edges, width = ww, height = hh)
# d3plus("rings", edges, focusDropdown = TRUE)
# d3plus("rings", edges, nodes = nodes,focusDropdown = TRUE)
# d3plus("network", edges)
# d3plus("network",edges,nodes = nodes)
p <- d3plus("tree", countries, width = ww, height = hh)
widgetThumbnail(p, thumbs["d3plus"], timeout = 2000)

library(isotope)
d <- read.csv(system.file("data/candidatos.csv",package="isotope"), stringsAsFactors = FALSE)
filterCols <- c("genero","profesiones", "niveldeestudios","talante", "pragmaticoideologico","visionpais")
sortCols <- c("nombre","apoyosenadores","apoyorepresentantes")
tpl <- '
<div style="border: 1px solid grey; margin:5px; padding:5px">
  <div class="container">
    <h3 class="nombre">{{nombre}}</h3>
    <div style="width:125px; height: 125px; margin:auto">
      <img src={{foto}} class="circle" width="100px"/>
    </div>
    <p>Profesión: {{profesiones}}, Género: {{genero}},Nivel de estudios: {{niveldeestudios}}</p>
    <div class="apoyosenadores"><em>Apoyo Senadores:</em> {{apoyosenadores}}</div>
    <div class="apoyorepresentantes"><em>Apoyo Representantes:</em> {{apoyorepresentantes}}</div>
  </div>
</div>
'
isotope(d, filterCols = filterCols, sortCols = sortCols, lang = 'es', elemTpl = tpl, ncols=3)
# save it manually...

library(D3TableFilter)
p <- d3tf(mtcars[,1:5], showRowNames = TRUE, initialFilters = list(col_1 = ">18"), width = ww, height = hh)
widgetThumbnail(p, thumbs["D3TableFilter"])

library(rhandsontable)
DF = data.frame(val = 1:10, bool = TRUE, big = LETTERS[1:10],
                small = letters[1:10],
                dt = seq(from = Sys.Date(), by = "days", length.out = 10),
                stringsAsFactors = F)
rhandsontable(DF, rowHeaders = NULL, width = ww, height = hh)
# save it manually...

library(rcdimple)
ex_data <- read.delim("http://pmsi-alignalytics.github.io/dimple/data/example_data.tsv")
colnames(ex_data) <- gsub("[.]","", colnames(ex_data))
p <- ex_data %>%
  dimple(x ="Month", y = "UnitSales", groups = 'Channel',
    type = "bar", width = 590, height = 400
  ) %>%
  set_bounds( x = 60, y = 30, width = 510, height = 290 ) %>%
  xAxis(orderRule = "Date") %>%
  add_legend(  ) %>%
  add_title( text = "Unit Sales each Month by Channel", width = ww, height = hh)
# doesn't seem to obey sizing...
widgetThumbnail(p, thumbs["rcdimple"])

library(sortableR)
# save manually

library(parcoords)
data(mtcars)
p <- parcoords(
  mtcars,
  reorderable = T,
  brushMode = "2d-strums",
  width = hh + 60, height = hh
)
# make a bid wider and manually crop
widgetThumbnail(p, thumbs["parcoords"])

library(listviewer)
p <- jsonedit(mtcars, width = ww, height = hh)
widgetThumbnail(p, thumbs["listviewer"])

library(svgPanZoom)
library(SVGAnnotation)
# svgPanZoom(
#   svgPlot(
#     plot(1:10)
#   )
# )
# rrg... x11... skip this one

library(exportwidget)
# not plottable

library(trailr)
# not plottable

library(imageR)
tf <- tempfile()
png( file = tf, height = 600, width = 600 )
plot(1:50)
dev.off()
intense(
  tags$img(
    style = "height:50%;"
    ,"data-title" = "sample intense plot"
    ,"data-caption" = "imageR at work"
    ,src = paste0("data:image/png;base64,",base64enc::base64encode(tf))
  ),
  width = ww, height = hh
)

library(plottableR)
# can't find examples...

library(chartist)
set.seed(324)
data <- data.frame(
  day = paste0("day", 1:10),
  A   = runif(10, 0, 10),
  B   = runif(10, 0, 10),
  C   = runif(10, 0, 10)
)
chartist(data, day) #, width = ww, height = hh)
# doesn't like sizing - do it manually...

library(phylowidget)
nwk <- "(((EELA:0.150276,CONGERA:0.213019):0.230956,(EELB:0.263487,CONGERB:0.202633):0.246917):0.094785,((CAVEFISH:0.451027,(GOLDFISH:0.340495,ZEBRAFISH:0.390163):0.220565):0.067778,((((((NSAM:0.008113,NARG:0.014065):0.052991,SPUN:0.061003,(SMIC:0.027806,SDIA:0.015298,SXAN:0.046873):0.046977):0.009822,(NAUR:0.081298,(SSPI:0.023876,STIE:0.013652):0.058179):0.091775):0.073346,(MVIO:0.012271,MBER:0.039798):0.178835):0.147992,((BFNKILLIFISH:0.317455,(ONIL:0.029217,XCAU:0.084388):0.201166):0.055908,THORNYHEAD:0.252481):0.061905):0.157214,LAMPFISH:0.717196,((SCABBARDA:0.189684,SCABBARDB:0.362015):0.282263,((VIPERFISH:0.318217,BLACKDRAGON:0.109912):0.123642,LOOSEJAW:0.397100):0.287152):0.140663):0.206729):0.222485,(COELACANTH:0.558103,((CLAWEDFROG:0.441842,SALAMANDER:0.299607):0.135307,((CHAMELEON:0.771665,((PIGEON:0.150909,CHICKEN:0.172733):0.082163,ZEBRAFINCH:0.099172):0.272338):0.014055,((BOVINE:0.167569,DOLPHIN:0.157450):0.104783,ELEPHANT:0.166557):0.367205):0.050892):0.114731):0.295021)"
p <- phylowidget(nwk, width = ww, height = hh)
widgetThumbnail(p, thumbs["phylowidget"])

library(sweep)
# can't find anything...

library(testjs)
x <- rnorm(100)
grp <- sample(1:3, 100, replace=TRUE)
y <- x*grp + rnorm(100)
p <- iplot(x, y, grp)
# won't accept dimensions
widgetThumbnail(p, thumbs["testjs"])

library(highchartR)
data = mtcars
x = 'wt'
y = 'mpg'
group = 'cyl'
highcharts(
    data = data,
    x = x,
    y = y,
    group = group,
    type = 'scatter'
)
# doesn't work

library(greatCircles)
p <- greatCircles(data.frame(
  longitude.start=c(-0.1015987,9.9278215,2.3470599,12.5359979,-42.9232368,114.1537584, 139.7103880,-118.4117325,-73.9796810,4.8986142,7.4259704,-1.7735460),
  latitude.start = c(51.52864,53.55857,48.85886,41.91007,-22.06645,22.36984,35.67334, 34.02050,40.70331,52.37472,43.74105,52.49033),
  longitude.finish = c(9.9278215,2.3470599,12.5359979,-42.9232368,114.1537584,139.7103880, -118.4117325,-73.9796810,4.8986142,7.4259704,-1.7735460,-0.1015987),
  latitude.finish = c(53.55857,48.85886,41.91007,-22.06645,22.36984,35.67334,34.02050, 40.70331,52.37472,43.74105,52.49033,51.52864)
), width = ww, height = hh)
widgetThumbnail(p, thumbs["great-circles"])

library(sparkline)
x = rnorm(20)
sparkline(x)
sparkline(x, type = 'bar')
sparkline(x, type = 'box')
# manually save...

library(rWordCloud)
# manaul...

library(c3r)
data(cars)
p <- c3_plot(cars, "speed", "dist", width = ww, height = hh)
widgetThumbnail(p, thumbs["c3r"])

library(dcStockR)
library(httr)
library(lubridate)
res <- GET("https://github.com/dc-js/dc.js/raw/master/web/ndx.csv")
ndx <- content(res, type = "text/csv")
ndx$date <- as.character(mdy(ndx$date))
# dc(ndx, "yearlyBubbleChart", title = "Yearly Performance (radius: fluctuation/index ratio, color: gain/loss)")
# dc(ndx, "gainOrLossChart", title = "Days by Gain/Loss", height = 300)
# dc(ndx, "quarterChart", title = "Quarters", height = 300)
# dc(ndx, "dayOfWeekChart", title = "Day of Week", height = 300)
# dc(ndx, "fluctuationChart", title = "Days by Fluctuation(%)", height = 300)
p <- dc(ndx, "moveChart", title = "Monthly Index Abs Move & Volume/500,000 Chart", width = ww, height = hh)
# dc(ndx, "dataCount")
# dc(ndx, "dataTable")
widgetThumbnail(p, thumbs["dcStockR"])

library(scatterMatrixD3)
scatterMatrix(data = iris, width = ww, height = hh)

library(d3heatmap)
p <- d3heatmap(mtcars, scale = "column", colors = "Spectral", width = ww, height = hh)
widgetThumbnail(p, "rstudio-d3heatmap.png")
