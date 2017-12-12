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

# functions ---------------------------------------------------------------

simulate <- function(p) {
  outdir <- paste0("output_", p$id, "_", p$app, "_", p$concurrency, "usr_", p$srv_conf, "_", p$duration)
  # if (!dir.exists(outdir)) dir.create(outdir)
  outpath <- "~/shiny-concurrency/shiny-server-pro/4_json"
  command <- paste0("cd ", outpath, "; ",
                    "rm -f ", outdir, "/*; ",
                    "mkdir -p ", outdir, "; ",
                    "~/shiny-concurrency/proxyrec playback ",
                    "--target 'http://ec2-52-201-221-45.compute-1.amazonaws.com:3838/", p$app, "/' ",
                    "--outdir ", outdir,
                    " --concurrency ", p$concurrency, "  --duration '", p$duration, "' ",
                    "../../tests/4_json/app-recording.txt &")
  message("running: ", command)
  out <-
    system(command, inter = FALSE)
  message("polling..")
  df <-
    shinyloadtest::poll(
      servers = c('ec2-52-201-221-45.compute-1.amazonaws.com:3838'),
      appName = 'shinyTest',
      duration_sec = p$time_monitor,
      platform = 'ssp'
    )
  list(poll       = df,
       outdir     = file.path(outpath, outdir),
       parameters = parameters,
       command    = command)
}

report_gen <- function(sim) {
  report_path = '~/shiny-concurrency/reports/shiny-server-pro'
  report_template_name = "report.Rmd"
  report_tmp = file.path(report_path, "report.html")
  #createLoadTestReport(dir = report_path, name = report_template_name)
  report_template <- file.path(report_path, report_template_name)
  directory   = sim$outdir #'~/shiny-concurrency/shiny-server-pro/4_json/output_10_mysql_001usr_4thr_100-090-40_2min_net/'
  output = strsplit(directory, split = "/")[[1]][5]
  report_file = file.path( report_path, paste0('report_', output, '.html') )

  rmarkdown::render(report_template,
                    params = list(directory = directory))
  file.rename(report_tmp, report_file)
}

# main --------------------------------------------------------------------

sim_param_1 <- list(id = "30",
                    app = "shinyTest",
                    concurrency = "1",
                    srv_conf = "100-090-40_net",
                    duration = "180sec",
                    time_monitor = 30)
sim_param_2 <- list(id = "31",
                    app = "shinyTest",
                    concurrency = "200",
                    srv_conf = "100-090-40_net",
                    duration = "180sec",
                    time_monitor = 30)

sim_1_out <-
  sim_param_1 %>%
  simulate
report_gen(sim_1_out)

sim_param_2 %>%
  simulate %>%
  report_gen



unlink('~/shiny-concurrency/shiny-server-pro/4_json/output_canc//profile_173_2.txt')

# reports -----------------------------------------------------------------

l = list(poll       = NA,
     outdir     = "~/shiny-concurrency/shiny-server-pro/4_json/output_10_mysql_001usr_4thr_100-090-40_2min_net/",
     parameters = NA,
     command    = NA)
log <- createLog(l$outdir)

report_gen(l)

list(poll       = NA,
     outdir     = "~/shiny-concurrency/shiny-server-pro/4_json/output_11_mysql_200usr_4thr_100-090-40_2min_net/",
     parameters = NA,
     command    = NA) %>%
  report_gen
list(poll       = NA,
     outdir     = "~/shiny-concurrency/shiny-server-pro/4_json/output_54_mysql_200usr_4thr_100-090-40_6min_vb/",
     parameters = NA,
     command    = NA) %>%
  report_gen
list(poll       = NA,
     outdir     = "~/shiny-concurrency/shiny-server-pro/4_json/output_52_mysql_001usr_4thr_100-090-40_2min_vb/",
     parameters = NA,
     command    = NA) %>%
  report_gen

