#install.packages('devtools')

#devtools::install_github("rstudio/shinyloadtest")

# install.packages("purrr")
# install.packages("ggplot2")
# install.packages("rsconnect")

library(rlang)
library(purrr)
library(ggplot2)
library(httr)
#install.packages('progress')
library(progress)
library(rsconnect)
library(shinyloadtest)

# main --------------------------------------------------------------------

shiny_server <- "ec2-52-91-131-141.compute-1.amazonaws.com"

sim_param_1 <- Simulation(id = "60",
                          app = "shinyTest",
                          concurrency = "1",
                          srv_conf = "100-090-40_net",
                          duration = "60sec",
                          time_monitor = 30,
                          shiny_server = shiny_server,
                          shiny_port   = "3838")
sim_param_2 <- Simulation(id = "61",
                          app = "shinyTest",
                          concurrency = "200",
                          srv_conf = "100-090-40_net",
                          duration = "180sec",
                          time_monitor = 30,
                          shiny_server = shiny_server,
                          shiny_port   = "3838")
app_url(sim_param_1)

cat(simulate_cmd(sim_param_1))
sim_1_out <- simulate(sim_param_1)
sim_1_rep <- report_gen(sim_1_out)
(sim_1_rep$file)
unlink('~/shiny-concurrency/shiny-server-pro/4_json/output_canc//profile_173_2.txt')

# reports -----------------------------------------------------------------

l = SimOut(poll       = NA,
           outdir     = "~/shiny-concurrency/shiny-server-pro/4_json/output_10_mysql_001usr_4thr_100-090-40_2min_net/",
           parameters = NA,
           command    = NA)
str(l)
log <- createLog(l$outdir)

report_gen(l)

SimOut(poll       = NA,
       outdir     = "~/shiny-concurrency/shiny-server-pro/4_json/output_11_mysql_200usr_4thr_100-090-40_2min_net/",
       parameters = NA,
       command    = NA) %>%
  report_gen
SimOut(poll       = NA,
       outdir     = "~/shiny-concurrency/shiny-server-pro/4_json/output_54_mysql_200usr_4thr_100-090-40_6min_vb/",
       parameters = NA,
       command    = NA) %>%
  report_gen
SimOut(poll       = NA,
       outdir     = "~/shiny-concurrency/shiny-server-pro/4_json/output_52_mysql_001usr_4thr_100-090-40_2min_vb/",
       parameters = NA,
       command    = NA) %>%
  report_gen


# shiny-proxy -------------------------------------------------------------

shiny_proxy <- "ec2-35-153-83-243.compute-1.amazonaws.com"
#shiny_proxy <- "172.30.3.104"
frame <- '    <iframe id="shinyframe" width="100%" src="/elated_carson/"></iframe>'

sim_param_3 <- SimulationProxy(id = "71",
                               app = "test_app",
                               concurrency = "1",
                               srv_conf = "100-090-40_net",
                               duration = "2min",
                               time_monitor = 30,
                               shiny_server = shiny_proxy,
                               shiny_port   = "8080", 
                               outpath = "~/shiny-concurrency/shiny-proxy/5_json",
                               rectest      = "../../tests/5_json_SP/app-recording.txt")
#containerLs <- map(containerStrings, Container, hash = NA,port = 8080)

containerLsB_generate <- function(id) {
  Container(name = ""
            , hash = NA
            , port = id +40000)
}
containerLsB <- purrr::map(1:150, containerLsB_generate)


simulationLs <- simulationLs_get.SimulationProxy(sim_param_3, containerLsB) 
s <- shinyConcurrency::simulate
simOutLs <- lapply(simulationLs, s)
simOutLs
system(command = "ps aux | grep proxyrec")
simProxyOutLs <- SimProxyOutLs(simOutLs)
listSimOutFiles.SimProxyOutLs(simProxyOutLs)[1:50]
moveFiles.SimProxyOutLs(simProxyOutLs)
simOut <- ToSimOut.SimProxyOutLs(simProxyOutLs)
simOut
report_gen(simOut)
# url <- paste0(app_url.SimulationProxy(sim_param_3), "/")
# url
# require(RCurl)
# 
# r = dynCurlReader()
# str(r)
# r$reset()                               # reset
# curlPerform(
#   #postfields = json_1,
#             url = url,                  # or uri
#             verbose = TRUE,
#             # userpwd = usr_pwd,
#             # httpauth = 1L,
#             # post = 1L,
#             writefunction = r$update)   # append the result
# html <- shinyProxyPage
# html <- r$value()
# strsplit(html, split = "\n")[[1]][82]
# substr()
