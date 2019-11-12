#include <stdio.h>

__uint128_t modProd( __uint128_t  A,__uint128_t B,__uint128_t n){
    __uint128_t P = 0;
    for (int i = 0; i < 128; i++){
        P = 2*P + A * ((B >> (127 - i)) & 1);
        P = P % n;
    }
return P;
}

int main(){
	__uint128_t M = 234521;
	__uint128_t n = 12342;
	__uint128_t e = 15514;
	__uint128_t result = 1;
	printf("%0.6g^%0.6g mod %0.6g =",(float)M,(float)e,(float)n);
	M %= n;
	while ( e > 0 ){
		if (e & 1 == 1 ){
			result = modProd(result,M,n);
		}
		M = modProd(M,M,n);	
		e = e >> 1;
	}
	printf(" %0.6g\n",(float)result);
}