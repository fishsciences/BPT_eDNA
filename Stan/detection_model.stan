
data{
    int<lower=1> N; // number of rows
    real AvgCQ[N]; // response vector
    real Vol[N]; // predictor
    real NSamples[N]; //predictor
}

parameters{
    real Intercept;
    real b_Vol_deci;
    real b_NSamples;
    real b_VolNSamples;
    real<lower=0> sigma;
}

model{
  
    vector[N] mu; // vector of averages equal to number of observations
    // priors
    sigma ~ cauchy( 0 , 2 );
    b_Vol_deci ~ normal( 0 , 10 );
    b_NSamples ~ normal( 0, 10 );
    b_VolNSamples ~ normal(0, 10);
    Intercept ~ normal( 0 , 10 );
    
    // model
    for ( i in 1:N ) {
        mu[i] = Intercept + b_Vol_deci * Vol[i] + b_NSamples * NSamples[i] + b_VolNSamples * Vol[i] * NSamples[i];
    }
    
    AvgCQ ~ normal( mu , sigma );
}

generated quantities{
  int detect[N];
  vector[N] y_pred;
  vector[N] mu;
  real dev = 0;

  for ( i in 1:N ) {
	mu[i] = Intercept + b_Vol_deci * Vol[i] + b_NSamples * NSamples[i]+ b_VolNSamples * Vol[i] * NSamples[i];
  }
  
  dev = dev + (-2)*normal_lpdf( AvgCQ | mu , sigma );
  
  // generate distribution over the detection probability, derived from modeled detection strength:
  for(n in 1:N){
	y_pred[n] = normal_rng(mu[n], sigma);

	if(y_pred[n] < 40){
	  detect[n] = 1;
		} else {
	  detect[n] = 0;
	}
  }
  
}
