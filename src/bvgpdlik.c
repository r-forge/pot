#include "header.h"

void gpdbvlog(double *data1, double *data2, int *n, double *lambda1,
	      double *lambda2, double *thresh, double *scale1,
	      double *shape1, double *scale2, double *shape2,
	      double *alpha, double *dns){

  int i;

  double eps, *t1, *t2, *z1, *z2, *dvec, v, nv1, nK1, nv2, nK2, v12;

  eps = R_pow(DOUBLE_EPS, 0.3);
  t1 = (double *)R_alloc(*n, sizeof(double));
  t2 = (double *)R_alloc(*n, sizeof(double));
  z1 = (double *)R_alloc(*n, sizeof(double));
  z2 = (double *)R_alloc(*n, sizeof(double));
  dvec = (double *)R_alloc(*n, sizeof(double));
  
  
  if(*alpha > 1 || *alpha < 0.05 || *scale1 < 0.01 ||
     *scale2 < 0.01){
    *dns = -1e6;
    return;
  }
  
  //+++++++++++++++++++++++++++++++++++++//
  //                                     //
  //Preliminary data transformation stage//
  //                                     //
  //+++++++++++++++++++++++++++++++++++++//

  for (i=0;i<*n;i++){

    //Margin 1
    t1[i] = (data1[i]  - thresh[0]) / *scale1;
        
    if (data1[i] <= thresh[0]){
      t1[i] = 1;
      data1[i] = 0;
    }

    else{

      if (fabs(*shape1) <= eps){
	*shape1 = 0;
	t1[i] = exp(-t1[i]);
      }

      else {
	t1[i] = 1 + *shape1 * t1[i];
      
	if (t1[i] <= 0){
	  *dns = -1e6;
	  return;
	}
      
	t1[i] = R_pow(t1[i], -1/ *shape1);
      
      }
    }

    //Margin 2
    t2[i] = (data2[i]  - thresh[1]) / *scale2;

    if (data2[i] <= thresh[1]){
      t2[i] = 1;
      data2[i] = 0;
    }

    else{

      if (fabs(*shape2) <= eps){
	*shape2 = 0;
	t2[i] = exp(-t2[i]);
      }

      else {
	t2[i] = 1 + *shape2 * t2[i];
      
	if (t2[i] <= 0){
	  *dns = -1e6;
	  return;
	}
      
	t2[i] = R_pow(t2[i], -1/ *shape2);
      
      }
    }
       
    //Transform observed datas to unit frechet ones
    z1[i] = -1 / log(1 - *lambda1 * t1[i]);
    z2[i] = -1 / log(1 - *lambda2 * t2[i]);
    
  }

  
  //+++++++++++++++++++++++++++++++++++++//
  //                                     //
  //     Log-likelihood contribution     //
  //                                     //
  //+++++++++++++++++++++++++++++++++++++//

  for (i=0;i<*n;i++){ 

    //Compute the bivariate logistic distribution at point
    //(z[1], z[2]) (but omitting the alpha power!!!)
    v = R_pow(z1[i], - 1 / *alpha) + R_pow(z2[i], - 1 / *alpha);
      
    if (data1[i] == 0){

      if(data2[i] == 0){
	//Case 1: x1 <= threshold1 & x2 <= threshold2
	dvec[i] = *alpha * log(v);
      }

      else{
	//Case 2: x1 <= threshold1 & x2 > threshold2
      
	//Compute the log negative partial derivative with
	//respect to the second component
	nv2 = -(1/ *alpha + 1) * log(z2[i]) +
	  (*alpha - 1) * log(v);
	
	//the log negative K2 constant of Ledford [1996]
	nK2 = log(*lambda2) - log(*scale2) + 
	  (1 + *shape2) * log(t2[i]) + 2 * log(z2[i]) +
	  1 / z2[i];
      
	dvec[i] = nv2 + nK2 - R_pow(v, *alpha);
     	
      }
    }

    else{
      
      if (data2[i] == 0){
	//Case 3: x1 > threshold1 & x2 <= threshold2
	
	//Compute the log negative partial derivative with
	//respect to the first component
	nv1 = -(1/ *alpha + 1) * log(z1[i]) +
	  (*alpha - 1) * log(v);
	
	//the log negative K1 constant of Ledford [1996]
	nK1 = log(*lambda1) - log(*scale1) + 
	  (1 + *shape1) * log(t1[i]) + 2 * log(z1[i]) +
	  1 / z1[i];
	
	dvec[i] = nv1 + nK1 - R_pow(v, *alpha);
	
      }

      else{
	//Case 4: x1 > threshold1 & x2 > threshold2
	
	//Compute the negative partial derivative with
	//respect to the first component
	nv1 = R_pow(z1[i], -1/ *alpha - 1) * 
	  R_pow(v, *alpha - 1);
	
	//the log negative K1 constant of Ledford [1996]
	nK1 = log(*lambda1) - log(*scale1) + 
	  (1 + *shape1) * log(t1[i]) + 2 * log(z1[i]) +
	  1 / z1[i];
	
	//Compute the negative partial derivative with
	//respect to the second component
	nv2 = R_pow(z2[i], -1/ *alpha - 1) * 
	  R_pow(v, *alpha - 1);
	
	//the log negative K2 constant of Ledford [1996]
	nK2 = log(*lambda2) - log(*scale2) + 
	  (1 + *shape2) * log(t2[i]) + 2 * log(z2[i]) +
	  1 / z2[i];
	
	//Compute the partial mixed derivative	
	v12 = (1 - 1 / *alpha) * R_pow(z1[i]*z2[i],
				       -1/ *alpha - 1) *
	  R_pow(v, *alpha - 2);
	
	dvec[i] = nK1 + nK2 + log(nv1 * nv2 - v12)
	  - R_pow(v, *alpha);
	  
      }
    }
  }
      
  for (i=0;i<(*n -1);i++)
    *dns = *dns + dvec[i];
}
    
void gpdbvalog(double *data1, double *data2, int *n, double *lambda1,
	       double *lambda2, double *thresh, double *scale1,
	       double *shape1, double *scale2, double *shape2,
	       double *alpha, double *asCoef1, double *asCoef2,
	       double *dns){

  int i;

  double eps, *t1, *t2, *z1, *z2, *dvec, v, nv1, nK1, nv2, nK2, v12;

  eps = R_pow(DOUBLE_EPS, 0.3);
  t1 = (double *)R_alloc(*n, sizeof(double));
  t2 = (double *)R_alloc(*n, sizeof(double));
  z1 = (double *)R_alloc(*n, sizeof(double));
  z2 = (double *)R_alloc(*n, sizeof(double));
  dvec = (double *)R_alloc(*n, sizeof(double));
  
  
  if(*alpha > 1 || *alpha < 0.05 || *scale1 < 0.01 ||
     *scale2 < 0.01 || *asCoef1 < 0 || *asCoef1 > 1 ||
     *asCoef2 < 0 || *asCoef2 > 1){
    *dns = -1e6;
    return;
  }
  
  //+++++++++++++++++++++++++++++++++++++//
  //                                     //
  //Preliminary data transformation stage//
  //                                     //
  //+++++++++++++++++++++++++++++++++++++//

  for (i=0;i<*n;i++){

    //Margin 1
    t1[i] = (data1[i]  - thresh[0]) / *scale1;
        
    if (data1[i] <= thresh[0]){
      t1[i] = 1;
      data1[i] = 0;
    }

    else{

      if (fabs(*shape1) <= eps){
	*shape1 = 0;
	t1[i] = exp(-t1[i]);
      }

      else {
	t1[i] = 1 + *shape1 * t1[i];
      
	if (t1[i] <= 0){
	  *dns = -1e6;
	  return;
	}
      
	t1[i] = R_pow(t1[i], -1/ *shape1);
      
      }
    }

    //Margin 2
    t2[i] = (data2[i]  - thresh[1]) / *scale2;

    if (data2[i] <= thresh[1]){
      t2[i] = 1;
      data2[i] = 0;
    }

    else{

      if (fabs(*shape2) <= eps){
	*shape2 = 0;
	t2[i] = exp(-t2[i]);
      }

      else {
	t2[i] = 1 + *shape2 * t2[i];
      
	if (t2[i] <= 0){
	  *dns = -1e6;
	  return;
	}
      
	t2[i] = R_pow(t2[i], -1/ *shape2);
      
      }
    }
       
    //Transform observed datas to unit frechet ones
    z1[i] = -1 / log(1 - *lambda1 * t1[i]);
    z2[i] = -1 / log(1 - *lambda2 * t2[i]);
  }

    
  //+++++++++++++++++++++++++++++++++++++//
  //                                     //
  //     Log-likelihood contribution     //
  //                                     //
  //+++++++++++++++++++++++++++++++++++++//

  for (i=0;i<*n;i++){ 

    //Compute the bivariate logistic distribution at point
    //(z[1], z[2])
    v = (1 - *asCoef1) / z1[i] + (1 - *asCoef2) / z2[i] +
      R_pow(R_pow(*asCoef1 / z1[i], 1 / *alpha) + 
	    R_pow(*asCoef2 / z2[i], 1 / *alpha), *alpha);
      
    if (data1[i] == 0){

      if(data2[i] == 0){
	//Case 1: x1 <= threshold1 & x2 <= threshold2
	dvec[i] = log(v);
      }

      else{
	//Case 2: x1 <= threshold1 & x2 > threshold2
      
	//Compute the negative partial derivative with
	//respect to the second component
	nv2 = (1 - *asCoef2) / R_pow_di(z2[i], 2) +
	  R_pow(*asCoef2, 1/ *alpha) *
	  R_pow(z2[i], -1/ *alpha - 1) *
	  R_pow(R_pow(*asCoef1 / z1[i], 1/ *alpha) + 
		R_pow(*asCoef2 / z2[i], 1/ *alpha), *alpha - 1);
	//the log negative K2 constant of Ledford [1996]
	nK2 = log(*lambda2) - log(*scale2) + 
	  (1 + *shape2) * log(t2[i]) + 2 * log(z2[i]) +
	  1 / z2[i];
      
	dvec[i] = log(nv2) + nK2 - v;
     	
      }
    }

    else{
      
      if (data2[i] == 0){
	//Case 3: x1 > threshold1 & x2 <= threshold2
	
	//Compute the negative partial derivative with
	//respect to the first component
	nv1 = (1 - *asCoef1) / R_pow_di(z1[i], 2) +
	  R_pow(*asCoef1, 1/ *alpha) * 
	  R_pow(z1[i], -1/ *alpha - 1) *
	  R_pow(R_pow(*asCoef1 / z1[i], 1/ *alpha) + 
		R_pow(*asCoef2 / z2[i], 1/ *alpha), *alpha - 1);
	
	//the log negative K1 constant of Ledford [1996]
	nK1 = log(*lambda1) - log(*scale1) + 
	  (1 + *shape1) * log(t1[i]) + 2 * log(z1[i]) +
	  1 / z1[i];
	
	dvec[i] = log(nv1) + nK1 - v;
	
      }

      else{
	//Case 4: x1 > threshold1 & x2 > threshold2
	
	//Compute the negative partial derivative with
	//respect to the first component
	nv1 = (1 - *asCoef1) / R_pow_di(z1[i], 2) +
	  R_pow(*asCoef1, 1/ *alpha) * 
	  R_pow(z1[i], -1/ *alpha - 1) *
	  R_pow(R_pow(*asCoef1 / z1[i], 1/ *alpha) + 
		R_pow(*asCoef2 / z2[i], 1/ *alpha), *alpha - 1);
	//the log negative K1 constant of Ledford [1996]
	nK1 = log(*lambda1) - log(*scale1) + 
	  (1 + *shape1) * log(t1[i]) + 2 * log(z1[i]) +
	  1 / z1[i];
	
	//Compute the negative partial derivative with
	//respect to the second component
	nv2 = (1 - *asCoef2) / R_pow_di(z2[i], 2) +
	  R_pow(*asCoef2, 1/ *alpha) *
	  R_pow(z2[i], -1/ *alpha - 1) *
	  R_pow(R_pow(*asCoef1 / z1[i], 1/ *alpha) + 
		R_pow(*asCoef2 / z2[i], 1/ *alpha), *alpha - 1);
	
	//the log negative K2 constant of Ledford [1996]
	nK2 = log(*lambda2) - log(*scale2) + 
	  (1 + *shape2) * log(t2[i]) + 2 * log(z2[i]) +
	  1 / z2[i];
	
	//Compute the partial mixed derivative	
	v12 = (1 - 1/ *alpha) * R_pow(*asCoef1 * *asCoef2, 1/ *alpha) *
	  R_pow(z1[i]*z2[i], -1/ *alpha - 1) *
	  R_pow(R_pow(*asCoef1 / z1[i], 1/ *alpha) + 
		R_pow(*asCoef2 / z2[i], 1/ *alpha), *alpha - 2);
	
	dvec[i] = nK1 + nK2 + log(nv1 * nv2 - v12) - v;
	  
      }
    }
  }
      
  for (i=0;i<(*n -1);i++)
    *dns = *dns + dvec[i];

}
    
void gpdbvnlog(double *data1, double *data2, int *n, double *lambda1,
	       double *lambda2, double *thresh, double *scale1,
	       double *shape1, double *scale2, double *shape2,
	       double *alpha, double *dns){

  int i;

  double eps, *t1, *t2, *z1, *z2, *dvec, v, nv1, nK1, nv2, nK2, v12;

  eps = R_pow(DOUBLE_EPS, 0.3);
  t1 = (double *)R_alloc(*n, sizeof(double));
  t2 = (double *)R_alloc(*n, sizeof(double));
  z1 = (double *)R_alloc(*n, sizeof(double));
  z2 = (double *)R_alloc(*n, sizeof(double));
  dvec = (double *)R_alloc(*n, sizeof(double));
  
  
  if(*alpha < 0.01 || *alpha > 15 || *scale1 < 0.01 || *scale2 < 0.01){
    *dns = -1e6;
    return;
  }
  
  //+++++++++++++++++++++++++++++++++++++//
  //                                     //
  //Preliminary data transformation stage//
  //                                     //
  //+++++++++++++++++++++++++++++++++++++//

  for (i=0;i<*n;i++){

    //Margin 1
    t1[i] = (data1[i]  - thresh[0]) / *scale1;
        
    if (data1[i] <= thresh[0]){
      t1[i] = 1;
      data1[i] = 0;
    }

    else{

      if (fabs(*shape1) <= eps){
	*shape1 = 0;
	t1[i] = exp(-t1[i]);
      }

      else {
	t1[i] = 1 + *shape1 * t1[i];
      
	if (t1[i] <= 0){
	  *dns = -1e6;
	  return;
	}
      
	t1[i] = R_pow(t1[i], -1/ *shape1);
      
      }
    }

    //Margin 2
    t2[i] = (data2[i]  - thresh[1]) / *scale2;

    if (data2[i] <= thresh[1]){
      t2[i] = 1;
      data2[i] = 0;
    }

    else{

      if (fabs(*shape2) <= eps){
	*shape2 = 0;
	t2[i] = exp(-t2[i]);
      }

      else {
	t2[i] = 1 + *shape2 * t2[i];
      
	if (t2[i] <= 0){
	  *dns = -1e6;
	  return;
	}
      
	t2[i] = R_pow(t2[i], -1/ *shape2);
      
      }
    }
       
    //Transform observed datas to unit frechet ones
    z1[i] = -1 / log(1 - *lambda1 * t1[i]);
    z2[i] = -1 / log(1 - *lambda2 * t2[i]);
    
  }

  
  //+++++++++++++++++++++++++++++++++++++//
  //                                     //
  //     Log-likelihood contribution     //
  //                                     //
  //+++++++++++++++++++++++++++++++++++++//

  for (i=0;i<*n;i++){ 

    //Compute the bivariate logistic distribution at point
    //(z[1], z[2])
    v = 1 / z1[i] + 1 / z2[i] -
      R_pow(R_pow(z1[i], *alpha) + R_pow(z2[i], *alpha),
	    - 1 / *alpha);
      
    if (data1[i] == 0){

      if(data2[i] == 0){
	//Case 1: x1 <= threshold1 & x2 <= threshold2
	dvec[i] = log(v);
      }

      else{
	//Case 2: x1 <= threshold1 & x2 > threshold2
      
	//Compute the negative partial derivative with
	//respect to the second component
	nv2 = R_pow_di(z2[i], -2) - R_pow(z2[i], *alpha -1) *
	  R_pow(R_pow(z1[i], *alpha) + R_pow(z2[i], *alpha),
		-1 / *alpha - 1);
	
	//the log negative K2 constant of Ledford [1996]
	nK2 = log(*lambda2) - log(*scale2) + 
	  (1 + *shape2) * log(t2[i]) + 2 * log(z2[i]) +
	  1 / z2[i];
      
	dvec[i] = log(nv2) + nK2 - v;
     	
      }
    }

    else{
      
      if (data2[i] == 0){
	//Case 3: x1 > threshold1 & x2 <= threshold2
	
	//Compute the negative partial derivative with
	//respect to the first component
	nv1 = R_pow_di(z1[i], -2) - R_pow(z1[i], *alpha -1) *
	  R_pow(R_pow(z1[i], *alpha) + R_pow(z2[i], *alpha),
		-1 / *alpha - 1);
	
	//the log negative K1 constant of Ledford [1996]
	nK1 = log(*lambda1) - log(*scale1) + 
	  (1 + *shape1) * log(t1[i]) + 2 * log(z1[i]) +
	  1 / z1[i];
	
	dvec[i] = log(nv1) + nK1 - v;
	
      }

      else{
	//Case 4: x1 > threshold1 & x2 > threshold2
	
	//Compute the negative partial derivative with
	//respect to the first component
	nv1 = R_pow_di(z1[i], -2) - R_pow(z1[i], *alpha -1) *
	  R_pow(R_pow(z1[i], *alpha) + R_pow(z2[i], *alpha),
		-1 / *alpha - 1);
	
	//the log negative K1 constant of Ledford [1996]
	nK1 = log(*lambda1) - log(*scale1) + 
	  (1 + *shape1) * log(t1[i]) + 2 * log(z1[i]) +
	  1 / z1[i];
	
	//Compute the negative partial derivative with
	//respect to the second component
	nv2 = R_pow_di(z2[i], -2) - R_pow(z2[i], *alpha -1) *
	  R_pow(R_pow(z1[i], *alpha) + R_pow(z2[i], *alpha),
		-1 / *alpha - 1);
	
	//the log negative K2 constant of Ledford [1996]
	nK2 = log(*lambda2) - log(*scale2) + 
	  (1 + *shape2) * log(t2[i]) + 2 * log(z2[i]) +
	  1 / z2[i];
	
	//Compute the partial mixed derivative	
	v12 = -(*alpha + 1) * R_pow(z1[i] * z2[i], *alpha - 1) *
	  R_pow(R_pow(z1[i], *alpha) + R_pow(z2[i], *alpha),
		- 1 / *alpha - 2);
	
	dvec[i] = nK1 + nK2 + log(nv1 * nv2 - v12)
	  - v;
	  
      }
    }
  }
      
  for (i=0;i<(*n -1);i++)
    *dns = *dns + dvec[i];
}

void gpdbvanlog(double *data1, double *data2, int *n, double *lambda1,
		double *lambda2, double *thresh, double *scale1,
		double *shape1, double *scale2, double *shape2, 
		double *alpha, double *asCoef1, double *asCoef2,
		double *dns){

  int i;

  double eps, *t1, *t2, *z1, *z2, *dvec, v, nv1, nK1, nv2, nK2, v12;

  eps = R_pow(DOUBLE_EPS, 0.3);
  t1 = (double *)R_alloc(*n, sizeof(double));
  t2 = (double *)R_alloc(*n, sizeof(double));
  z1 = (double *)R_alloc(*n, sizeof(double));
  z2 = (double *)R_alloc(*n, sizeof(double));
  dvec = (double *)R_alloc(*n, sizeof(double));
  
  
  if(*alpha < 0.2 || *alpha > 15 || *scale1 < 0.01 || *scale2 < 0.01 ||
     *asCoef1 < 0 || *asCoef1 > 1 || *asCoef2 < 0 || *asCoef2 > 1){
    *dns = -1e6;
    return;
  }
  
  //+++++++++++++++++++++++++++++++++++++//
  //                                     //
  //Preliminary data transformation stage//
  //                                     //
  //+++++++++++++++++++++++++++++++++++++//

  for (i=0;i<*n;i++){

    //Margin 1
    t1[i] = (data1[i]  - thresh[0]) / *scale1;
        
    if (data1[i] <= thresh[0]){
      t1[i] = 1;
      data1[i] = 0;
    }

    else{

      if (fabs(*shape1) <= eps){
	*shape1 = 0;
	t1[i] = exp(-t1[i]);
      }

      else {
	t1[i] = 1 + *shape1 * t1[i];
      
	if (t1[i] <= 0){
	  *dns = -1e6;
	  return;
	}
      
	t1[i] = R_pow(t1[i], -1/ *shape1);
      
      }
    }

    //Margin 2
    t2[i] = (data2[i]  - thresh[1]) / *scale2;

    if (data2[i] <= thresh[1]){
      t2[i] = 1;
      data2[i] = 0;
    }

    else{

      if (fabs(*shape2) <= eps){
	*shape2 = 0;
	t2[i] = exp(-t2[i]);
      }

      else {
	t2[i] = 1 + *shape2 * t2[i];
      
	if (t2[i] <= 0){
	  *dns = -1e6;
	  return;
	}
      
	t2[i] = R_pow(t2[i], -1/ *shape2);
      
      }
    }
       
    //Transform observed datas to unit frechet ones
    z1[i] = -1 / log(1 - *lambda1 * t1[i]);
    z2[i] = -1 / log(1 - *lambda2 * t2[i]);
    
  }

  
  //+++++++++++++++++++++++++++++++++++++//
  //                                     //
  //     Log-likelihood contribution     //
  //                                     //
  //+++++++++++++++++++++++++++++++++++++//

  for (i=0;i<*n;i++){ 

    //Compute the bivariate logistic distribution at point
    //(z[1], z[2])
    v = 1 / z1[i] + 1 / z2[i] -
      R_pow(R_pow(z1[i] / *asCoef1, *alpha) +
	    R_pow(z2[i] / *asCoef2, *alpha), - 1 / *alpha);
      
    if (data1[i] == 0){

      if(data2[i] == 0){
	//Case 1: x1 <= threshold1 & x2 <= threshold2
	dvec[i] = log(v);
      }

      else{
	//Case 2: x1 <= threshold1 & x2 > threshold2
      
	//Compute the negative partial derivative with
	//respect to the second component
	nv2 = R_pow_di(z2[i], -2) - R_pow(*asCoef2, - *alpha) *
	  R_pow(z2[i], *alpha -1) *
	  R_pow(R_pow(z1[i] / *asCoef1, *alpha) +
		R_pow(z2[i] / *asCoef2, *alpha),
		-1 / *alpha - 1);
	
	//the log negative K2 constant of Ledford [1996]
	nK2 = log(*lambda2) - log(*scale2) + 
	  (1 + *shape2) * log(t2[i]) + 2 * log(z2[i]) +
	  1 / z2[i];
      
	dvec[i] = log(nv2) + nK2 - v;
     	
      }
    }

    else{
      
      if (data2[i] == 0){
	//Case 3: x1 > threshold1 & x2 <= threshold2
	
	//Compute the negative partial derivative with
	//respect to the first component
	nv1 = R_pow_di(z1[i], -2) - R_pow(*asCoef1, - *alpha) *
	  R_pow(z1[i], *alpha -1) *
	  R_pow(R_pow(z1[i] / *asCoef1, *alpha) +
		R_pow(z2[i] / *asCoef2, *alpha),
		-1 / *alpha - 1);
	
	//the log negative K1 constant of Ledford [1996]
	nK1 = log(*lambda1) - log(*scale1) + 
	  (1 + *shape1) * log(t1[i]) + 2 * log(z1[i]) +
	  1 / z1[i];
	
	dvec[i] = log(nv1) + nK1 - v;
	
      }

      else{
	//Case 4: x1 > threshold1 & x2 > threshold2
	
	//Compute the negative partial derivative with
	//respect to the first component
	nv1 = R_pow_di(z1[i], -2) - R_pow(*asCoef1, - *alpha) *
	  R_pow(z1[i], *alpha -1) *
	  R_pow(R_pow(z1[i] / *asCoef1, *alpha) +
		R_pow(z2[i] / *asCoef2, *alpha),
		-1 / *alpha - 1);
		
	//the log negative K1 constant of Ledford [1996]
	nK1 = log(*lambda1) - log(*scale1) + 
	  (1 + *shape1) * log(t1[i]) + 2 * log(z1[i]) +
	  1 / z1[i];
	
	//Compute the negative partial derivative with
	//respect to the second component
	nv2 = R_pow_di(z2[i], -2) - R_pow(*asCoef2, - *alpha) *
	  R_pow(z2[i], *alpha -1) *
	  R_pow(R_pow(z1[i] / *asCoef1, *alpha) +
		R_pow(z2[i] / *asCoef2, *alpha),
		-1 / *alpha - 1);
		
	//the log negative K2 constant of Ledford [1996]
	nK2 = log(*lambda2) - log(*scale2) + 
	  (1 + *shape2) * log(t2[i]) + 2 * log(z2[i]) +
	  1 / z2[i];
	
	//Compute the partial mixed derivative	
	v12 = -(*alpha + 1) * R_pow(*asCoef1 * *asCoef2, - *alpha) *
	  R_pow(z1[i] * z2[i], *alpha - 1) *
	  R_pow(R_pow(z1[i] / *asCoef1, *alpha) +
		R_pow(z2[i] / *asCoef2, *alpha), - 1 / *alpha - 2);
	
	dvec[i] = nK1 + nK2 + log(nv1 * nv2 - v12)
	  - v;
	  
      }
    }
  }
      
  for (i=0;i<(*n -1);i++)
    *dns = *dns + dvec[i];
}

void gpdbvmix(double *data1, double *data2, int *n, double *lambda1,
	      double *lambda2, double *thresh, double *scale1,
	      double *shape1, double *scale2, double *shape2,
	      double *alpha, double *dns){

  int i;

  double eps, *t1, *t2, *z1, *z2, *dvec, v, nv1, nK1, nv2, nK2, v12;

  eps = R_pow(DOUBLE_EPS, 0.3);
  t1 = (double *)R_alloc(*n, sizeof(double));
  t2 = (double *)R_alloc(*n, sizeof(double));
  z1 = (double *)R_alloc(*n, sizeof(double));
  z2 = (double *)R_alloc(*n, sizeof(double));
  dvec = (double *)R_alloc(*n, sizeof(double));
  
  
  if(*alpha > 1 || *alpha < 0 || *scale1 < 0.01 ||
     *scale2 < 0.01){
    *dns = -1e6;
    return;
  }
  
  //+++++++++++++++++++++++++++++++++++++//
  //                                     //
  //Preliminary data transformation stage//
  //                                     //
  //+++++++++++++++++++++++++++++++++++++//

  for (i=0;i<*n;i++){

    //Margin 1
    t1[i] = (data1[i]  - thresh[0]) / *scale1;
        
    if (data1[i] <= thresh[0]){
      t1[i] = 1;
      data1[i] = 0;
    }

    else{

      if (fabs(*shape1) <= eps){
	*shape1 = 0;
	t1[i] = exp(-t1[i]);
      }

      else {
	t1[i] = 1 + *shape1 * t1[i];
      
	if (t1[i] <= 0){
	  *dns = -1e6;
	  return;
	}
      
	t1[i] = R_pow(t1[i], -1/ *shape1);
      
      }
    }

    //Margin 2
    t2[i] = (data2[i]  - thresh[1]) / *scale2;

    if (data2[i] <= thresh[1]){
      t2[i] = 1;
      data2[i] = 0;
    }

    else{

      if (fabs(*shape2) <= eps){
	*shape2 = 0;
	t2[i] = exp(-t2[i]);
      }

      else {
	t2[i] = 1 + *shape2 * t2[i];
      
	if (t2[i] <= 0){
	  *dns = -1e6;
	  return;
	}
      
	t2[i] = R_pow(t2[i], -1/ *shape2);
      
      }
    }
       
    //Transform observed datas to unit frechet ones
    z1[i] = -1 / log(1 - *lambda1 * t1[i]);
    z2[i] = -1 / log(1 - *lambda2 * t2[i]);
    
  }

  
  //+++++++++++++++++++++++++++++++++++++//
  //                                     //
  //     Log-likelihood contribution     //
  //                                     //
  //+++++++++++++++++++++++++++++++++++++//

  for (i=0;i<*n;i++){ 

    //Compute the bivariate logistic distribution at point
    //(z[1], z[2])
    v = R_pow_di(z1[i], - 1) + R_pow_di(z2[i], - 1) -
      *alpha / (z1[i] + z2[i]);
      
    if (data1[i] == 0){

      if(data2[i] == 0){
	//Case 1: x1 <= threshold1 & x2 <= threshold2
	dvec[i] = log(v);
      }

      else{
	//Case 2: x1 <= threshold1 & x2 > threshold2
      
	//Compute the negative partial derivative with
	//respect to the second component
	nv2 = R_pow_di(z2[i], -2) - *alpha * 
	  R_pow_di(z1[i] + z2[i], -2);
	
	//the log negative K2 constant of Ledford [1996]
	nK2 = log(*lambda2) - log(*scale2) + 
	  (1 + *shape2) * log(t2[i]) + 2 * log(z2[i]) +
	  1 / z2[i];
      
	dvec[i] = log(nv2) + nK2 - v;
     	
      }
    }

    else{
      
      if (data2[i] == 0){
	//Case 3: x1 > threshold1 & x2 <= threshold2
	
	//Compute the negative partial derivative with
	//respect to the first component
	nv1 = R_pow_di(z1[i], -2) - *alpha * 
	  R_pow_di(z1[i] + z2[i], -2);
	
	//the log negative K1 constant of Ledford [1996]
	nK1 = log(*lambda1) - log(*scale1) + 
	  (1 + *shape1) * log(t1[i]) + 2 * log(z1[i]) +
	  1 / z1[i];
	
	dvec[i] = log(nv1) + nK1 - v;
	
      }

      else{
	//Case 4: x1 > threshold1 & x2 > threshold2
	
	//Compute the negative partial derivative with
	//respect to the first component
	nv1 = R_pow_di(z1[i], -2) - *alpha * 
	  R_pow_di(z1[i] + z2[i], -2);
	
	//the log negative K1 constant of Ledford [1996]
	nK1 = log(*lambda1) - log(*scale1) + 
	  (1 + *shape1) * log(t1[i]) + 2 * log(z1[i]) +
	  1 / z1[i];
	
	//Compute the negative partial derivative with
	//respect to the second component
	nv2 = R_pow_di(z2[i], -2) - *alpha * 
	  R_pow_di(z1[i] + z2[i], -2);
	
	//the log negative K2 constant of Ledford [1996]
	nK2 = log(*lambda2) - log(*scale2) + 
	  (1 + *shape2) * log(t2[i]) + 2 * log(z2[i]) +
	  1 / z2[i];
	
	//Compute the partial mixed derivative	
	v12 = -2 * *alpha * R_pow_di(z1[i] + z2[i], -3);
	
	dvec[i] = nK1 + nK2 + log(nv1 * nv2 - v12)
	  - v;
	  
      }
    }
  }
      
  for (i=0;i<(*n -1);i++)
    *dns = *dns + dvec[i];
}

void gpdbvamix(double *data1, double *data2, int *n, double *lambda1,
	       double *lambda2, double *thresh, double *scale1,
	       double *shape1, double *scale2, double *shape2,
	       double *alpha, double *asCoef, double *dns){
  
  int i;

  double eps, *t1, *t2, *z1, *z2, *dvec, v, nv1, nK1, nv2,
    nK2, v12, c1;

  eps = R_pow(DOUBLE_EPS, 0.3);
  t1 = (double *)R_alloc(*n, sizeof(double));
  t2 = (double *)R_alloc(*n, sizeof(double));
  z1 = (double *)R_alloc(*n, sizeof(double));
  z2 = (double *)R_alloc(*n, sizeof(double));
  dvec = (double *)R_alloc(*n, sizeof(double));
  
  
  if(*alpha < 0  || *scale1 < 0.01 || *scale2 < 0.01 ||
     *alpha + 2 * *asCoef > 1 || *alpha + 3 * *asCoef < 0 ||
     *alpha + *asCoef > 1){
    *dns = -1e6;
    return;
  }
  
  //+++++++++++++++++++++++++++++++++++++//
  //                                     //
  //Preliminary data transformation stage//
  //                                     //
  //+++++++++++++++++++++++++++++++++++++//

  for (i=0;i<*n;i++){

    //Margin 1
    t1[i] = (data1[i]  - thresh[0]) / *scale1;
        
    if (data1[i] <= thresh[0]){
      t1[i] = 1;
      data1[i] = 0;
    }

    else{

      if (fabs(*shape1) <= eps){
	*shape1 = 0;
	t1[i] = exp(-t1[i]);
      }

      else {
	t1[i] = 1 + *shape1 * t1[i];
      
	if (t1[i] <= 0){
	  *dns = -1e6;
	  return;
	}
      
	t1[i] = R_pow(t1[i], -1/ *shape1);
      
      }
    }

    //Margin 2
    t2[i] = (data2[i]  - thresh[1]) / *scale2;

    if (data2[i] <= thresh[1]){
      t2[i] = 1;
      data2[i] = 0;
    }

    else{

      if (fabs(*shape2) <= eps){
	*shape2 = 0;
	t2[i] = exp(-t2[i]);
      }

      else {
	t2[i] = 1 + *shape2 * t2[i];
      
	if (t2[i] <= 0){
	  *dns = -1e6;
	  return;
	}
      
	t2[i] = R_pow(t2[i], -1/ *shape2);
      
      }
    }
       
    //Transform observed datas to unit frechet ones
    z1[i] = -1 / log(1 - *lambda1 * t1[i]);
    z2[i] = -1 / log(1 - *lambda2 * t2[i]);
    
  }

  
  //+++++++++++++++++++++++++++++++++++++//
  //                                     //
  //     Log-likelihood contribution     //
  //                                     //
  //+++++++++++++++++++++++++++++++++++++//

  for (i=0;i<*n;i++){ 

    //Compute the bivariate logistic distribution at point
    //(z[1], z[2])
    //c1 is a common value for cases 1 - 4
    c1 = ((*alpha + *asCoef) * z1[i] + (*alpha + 2 * *asCoef) *
	  z2[i]) / R_pow_di(z1[i] + z2[i], 2);
    v = 1/z1[i] + 1/z2[i] - c1;
      
    if (data1[i] == 0){

      if(data2[i] == 0){
	//Case 1: x1 <= threshold1 & x2 <= threshold2
	dvec[i] = log(v);
      }

      else{
	//Case 2: x1 <= threshold1 & x2 > threshold2
      
	//Compute the negative partial derivative with
	//respect to the second component
	nv2 = R_pow_di(z2[i], -2) + (*alpha + 2 * *asCoef) / 
	  R_pow_di(z1[i] + z2[i], 2) - 2 * c1 /
	  (z1[i] + z2[i]);
	
	//the log negative K2 constant of Ledford [1996]
	nK2 = log(*lambda2) - log(*scale2) + 
	  (1 + *shape2) * log(t2[i]) + 2 * log(z2[i]) +
	  1 / z2[i];
      
	dvec[i] = log(nv2) + nK2 - v;
     	
      }
    }

    else{
      
      if (data2[i] == 0){
	//Case 3: x1 > threshold1 & x2 <= threshold2
	
	//Compute the negative partial derivative with
	//respect to the first component
	nv1 = R_pow_di(z1[i], -2) + (*alpha + *asCoef) / 
	  R_pow_di(z1[i] + z2[i], 2) - 2 * c1 /
	  (z1[i] + z2[i]);
	
	//the log negative K1 constant of Ledford [1996]
	nK1 = log(*lambda1) - log(*scale1) + 
	  (1 + *shape1) * log(t1[i]) + 2 * log(z1[i]) +
	  1 / z1[i];
	
	dvec[i] = log(nv1) + nK1 - v;
	
      }

      else{
	//Case 4: x1 > threshold1 & x2 > threshold2
	
	//Compute the negative partial derivative with
	//respect to the first component
	nv1 = R_pow_di(z1[i], -2) + (*alpha + *asCoef) / 
	  R_pow_di(z1[i] + z2[i], 2) - 2 * c1 /
	  (z1[i] + z2[i]);
	
	//the log negative K1 constant of Ledford [1996]
	nK1 = log(*lambda1) - log(*scale1) + 
	  (1 + *shape1) * log(t1[i]) + 2 * log(z1[i]) +
	  1 / z1[i];
	
	//Compute the negative partial derivative with
	//respect to the second component
	nv2 = R_pow_di(z2[i], -2) + (*alpha + 2 * *asCoef) / 
	  R_pow_di(z1[i] + z2[i], 2) - 2 * c1 /
	  (z1[i] + z2[i]);
	
	//the log negative K2 constant of Ledford [1996]
	nK2 = log(*lambda2) - log(*scale2) + 
	  (1 + *shape2) * log(t2[i]) + 2 * log(z2[i]) +
	  1 / z2[i];
	
	//Compute the partial mixed derivative	
	v12 = (4 * *alpha + 6 * *asCoef) / 
	  R_pow_di(z1[i] + z2[i], 3) - 6 * c1 /
	  R_pow_di(z1[i] + z2[i], 2);
		
	dvec[i] = nK1 + nK2 + log(nv1 * nv2 - v12)
	  - v;
      }
    }
  }
      
  for (i=0;i<(*n -1);i++)
    *dns = *dns + dvec[i];
}
