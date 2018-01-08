dimension=128;

c0=1;
c1=nchoosek(dimension,1);
c2=nchoosek(dimension,2);
c3=nchoosek(dimension,3);
c4=nchoosek(dimension,4);

X=[];
X=[X;zeros(c0,4)];
X=[X;combnk(1:dimension,1),zeros(c1,3)];
X=[X;combnk(1:dimension,2),zeros(c2,2)];
X=[X;combnk(1:dimension,3),zeros(c3,1)];
X=[X;combnk(1:dimension,4)];

save('X4.mat','X');
