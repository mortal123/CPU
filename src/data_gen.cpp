#include <iostream>
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <queue>
#include <set>
#include <map>
#include <string>
#include <bitset>

typedef long long LL;
#define pb push_back
#define MPII make_pair<int, int>
#define PII pair<int, int>
#define sz(x) (int)x.size()

using namespace std;

template<class T> T abs(T x){if (x < 0) return -x; else return x;}

int main(){
	freopen("ram.data", "w", stdout);
	int c[10];
	for (int i = 1; i <= 100; ++i){
		int x = i, tot = 0;
		while (x > 0){
			c[++tot] = x % 16;
			x >>= 4;
		}
		for (int j = 8; j > tot; --j) putchar('0');
		for (int j = tot; j >= 1; --j){
			if (c[j] < 10) printf("%d", c[j]); else putchar('a' + c[j] - 10);
		}
		puts("");
	}
	return 0;
}

