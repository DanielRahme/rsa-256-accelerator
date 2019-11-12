#include <stdio.h>
#include <stdbool.h>
#include <math.h>
#include <stdlib.h>

int msbSize(__uint128_t a){
    return (int)log2(a);
}

long my_mod(__uint128_t carry, __uint128_t n){
    if (n == 0){return carry;} 
    int k = 0;
    int i = 0;
    int kc = msbSize(n) + 1;
    bool finished = false;
    while (!finished){ 
	    k = msbSize(carry) - kc;
	    k < 0 ? k = 0 : 0;
        carry -= ( n << k );
        carry < n ? finished = true : 0;
      
        printf("C(%d) = %g,  k = %d \n",i, (float)carry, k);
	    i++;
    }
return carry;
}


void main(){
    __uint128_t B = 3e35;
    B+= 7;
    __uint128_t n = 3;//3e38;
    printf("msbSize(B) = %d\n",msbSize(B));
    __uint128_t ans = my_mod(B,n);
    printf("my: %g mod %g = %g\n", (float)B, (float)n, (float)ans);
    printf(" C: %g mod %g = %g\n", (float)B, (float)n, (float)(B%n));
}

