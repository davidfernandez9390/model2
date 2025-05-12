library(ggplot2)

source('model.R')

get.strategies <- function() {
  #retorna un vector de strings amb els noms de les estratègies
  return(c('untreated', 'screening', 'treatment'))
}

get.parameters <- function() {
  #retorna una llista de llistes on cada subllista té els elements:
  #name = string amb el nom (obligatori)
  #base.value= valor numèric base (obligatori)
  #max.value=ELIMINAR-LO
  #stratum= string amb el nom de l'estrat si el paràmetre està estratificat (opcional)
  #class= string amb el tipus de paràmetre per possible classificación en l'input de l'interfície (opcional)
  return(list(
    list(
      name='p.healthy.cancer',
      base.value=0.9,
      max.value=1,
      stratum="30-35", 
      class="probability"
    ),
    list(
      name='p.healthy.cancer',
      base.value=1,
      max.value=1,
      stratum="35-40",
      class="probability"
    ),
    list(
      name='p.healthy.death',
      base.value=0.005,
      class="probability"
    ),
    list(
      name='p.cancer.death',
      base.value=0.5,
      class="probability"
    ),
    list(
      name='p.screening.effective',
      base.value=0.5,
      class="probability"
    ),
    list(
      name='p.treatment.effective',
      base.value=0.005,
      class="probability"
    ),
    list(
      name='cost.screening',
      base.value=500,
      class="cost"
    ),
    list(
      name='cost.cancer.treatment',
      base.value=10000,
      max.value=50000,
      class="cost"
    ),
    list(
      name='utility.cancer',
      base.value=0.5
    ),
    list(
      name='simulated.years',
      base.value=20
    ),
    list(
      name='discount',
      base.value=0.0
    )
  ))
}

run.simulation <- function(strategies, pars, progress = NULL) {
  
  # Exemple de l'estructura de pars:
  #   pars = list(
  #     'p.healthy.cancer'= list("30-35" = 0.05, "35-40" = 0.1),  # paràmetre estratificat
  #     "cost.treatment" = 10003                                   # paràmetre simple
  # 
  #
  # Per accedir als valors dels paràmetres de pars:
  #   - Estratificats: pars[['p.healthy.cancer']][["35-40"]]
  #   - Simples: pars[["cost.treatment"]]
  
  results <- simulate(strategies,
                      p.healthy.cancer_30_35=pars[['p.healthy.cancer']][['30-35']],
                      p.healthy.cancer_35_40=pars[['p.healthy.cancer']][['35-40']],
                      p.healthy.death=pars[['p.healthy.death']],
                      p.cancer.death=pars[['p.cancer.death']],
                      p.screening.effective=pars[['p.screening.effective']],
                      p.treatment.effective=pars[['p.treatment.effective']],
                      cost.screening=pars[['cost.screening']],
                      cost.cancer.treatment=pars[['cost.cancer.treatment']],
                      utility.cancer=pars[['utility.cancer']],
                      simulated.years=pars[['simulated.years']],
                      discount=pars[['discount']])
  return(results)
}



# ### TEST
#
# strategies <- get.strategies()
# param.info <- get.parameters()
# param.values <- sapply(param.info, function(p) p$base.value)
# names(param.values) <- sapply(param.info, function(p) p$name)
#
# results <- run.simulation(strategies, param.values)
# print(results$summary)
#
# print(
#   ggplot(results$summary, aes(x=C, y=E, color=strategy)) +
#     geom_point(size=3) +
#     coord_cartesian(xlim=c(0, max(results$summary$C)), ylim=c(0, 20)) +
#     theme_minimal()
# )

