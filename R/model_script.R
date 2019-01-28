library(rstan)
mod <- stan_model("Stan/Detection_model.stan")

dbin <- readRDS("Data/model_data.rds")

datalist <- list(N = nrow(dbin),
                 AvgCQ = dbin$AvgCQ,
                 Vol = dbin$Vol_deci,
                 NSamples = dbin$NSamples
  
)
datalist

modfit <- sampling(mod, data = datalist, iter = 1000, seed = 1234)

print(modfit, pars = c("Intercept", "b_Vol_deci", "b_NSamples", "b_VolNSamples", "detect"), probs = c(0.025, 0.975))
