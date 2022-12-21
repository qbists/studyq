//https://github.com/adotsch/aoc/blob/master/2022/19.c

#define geo 3
#define obs 2
#define cla 1
#define ore 0

#include "k.h"

int N;

int f(const int B[4][4],int*maxg,int n,int*s,int*r)
{
    if(n==N)
    {
        if(s[geo]>*maxg)
            *maxg = s[geo];
        return s[geo];
    }
    else if(n==N-1)
    {
        if(*maxg>=s[geo]+r[geo])
            return *maxg;
    }
    else
    {
        int e = s[geo] + (N-n)*r[geo] + 
            (((s[ore]>=B[geo][ore])&&(s[obs]>=B[geo][obs])) ? ((N-n)*(N-n-1)/2) : ((N-n-1)*(N-n-2)/2));
        if(*maxg>=e)
            return *maxg;
    }
    int m = 0;
    if((s[ore]>=B[geo][ore])&&(s[obs]>=B[geo][obs]))
    {
        int s0[4] = {s[0]+r[0]-B[geo][ore],s[1]+r[1],s[2]+r[2]-B[geo][obs],s[3]+r[3]};
        int r0[4] = {r[0],r[1],r[2],r[3]+1};
        int m0 = f(B,maxg,n+1,s0,r0);
        if(m0>m)m=m0;
    }
    if((s[ore]>=B[obs][ore])&&(s[cla]>=B[obs][cla]))
    {
        int s0[4] = {s[0]+r[0]-B[obs][ore],s[1]+r[1]-B[obs][cla],s[2]+r[2],s[3]+r[3]};
        int r0[4] = {r[0],r[1],r[2]+1,r[3]};
        int m0 = f(B,maxg,n+1,s0,r0);
        if(m0>m)m=m0;
    }
    if(s[ore]>=B[cla][ore])
    {
        int s0[4] = {s[0]+r[0]-B[cla][ore],s[1]+r[1],s[2]+r[2],s[3]+r[3]};
        int r0[4] = {r[0],r[1]+1,r[2],r[3]};
        int m0 = f(B,maxg,n+1,s0,r0);
        if(m0>m)m=m0;
    }
    if(s[ore]>=B[ore][ore])
    {
        int s0[4] = {s[0]+r[0]-B[ore][ore],s[1]+r[1],s[2]+r[2],s[3]+r[3]};
        int r0[4] = {r[0]+1,r[1],r[2],r[3]};
        int m0 = f(B,maxg,n+1,s0,r0);
        if(m0>m)m=m0;
    }
    {
        int s0[4] = {s[0]+r[0],s[1]+r[1],s[2]+r[2],s[3]+r[3]};
        int m0 = f(B,maxg,n+1,s0,r);
        if(m0>m)m=m0;
    }
    return m;
}

int geti(K B,S x,S y)
{
    K i = k(0,"{x[y;z]}",r1(B),ks(x),ks(y),0);
    int r = i->i;
    r0(i);
    R r;
}

K ff(K N_, K B_)
{
    N = N_->j;
    int B[4][4] = {
        {geti(B_,"ore","ore"), 0, 0, 0},
        {geti(B_,"cla","ore"), 0, 0, 0},
        {geti(B_,"obs","ore"), geti(B_,"obs","cla"), 0, 0},
        {geti(B_,"geo","ore"), 0, geti(B_,"geo","obs"), 0}
    };
    int s[4] = {0,0,0,0};
    int r[4] = {1,0,0,0};
    int maxg=0;
    int re = f(B,&maxg,0,s,r);
    __builtin_printf("..%i..\n",re);
    R kj(re);
}