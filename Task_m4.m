tic;
global dimension;
dimension=128;
change=4;

yinit=randi([0,1],1,dimension); 
xinit=yinit;
noHF = 42;

load('X4.mat');
%%% run datacollector.mat once if X4.mat is not saved

noDP=0;
for i=0:change
    noDP=noDP+nchoosek(dimension,i);
end

avone=(1+nchoosek(dimension-1,1)+nchoosek(dimension-1,2)+nchoosek(dimension-1,3)+nchoosek(dimension-1,4))...
    /(1+nchoosek(dimension,1)+nchoosek(dimension,2)+nchoosek(dimension,3)+nchoosek(dimension,4));
avzero=1-avone;

avpoint=zeros(1,dimension);
for i=1:dimension
    if(xinit(i)==1)
        avpoint(i)=avone;
    else
        avpoint(i)=avzero;
    end
end

changedy=randperm(128,4); %random positions of bit reversal

A=randi([0,1],noHF,dimension)-.5; %noHF number of random planes
ref=zeros(1,noHF);

for j=1:noHF
    for k=1:dimension
        ref(j)=ref(j)+(xinit(k)-avpoint(k))*A(j,k); 
    end
end

dot=zeros(noDP,noHF);
querydot=zeros(1,noHF);

%%calculation of hash code of the query code --> querydot
for j=1:noHF
    for k=1:4
        if(changedy(k)~=0)
            if(xinit(changedy(k))==0)
                querydot(j)=querydot(j)+A(j,(changedy(k)));
            else
                querydot(j)=querydot(j)-A(j,(changedy(k)));
            end
        end
    end
    if(querydot(j)>=(-ref(j)))
        querydot(j)=1;
    else
        querydot(j)=0;
    end
end
   
%%search in the sample space X4
optim=zeros(noDP,1);
for i=1:noDP
    for j=1:noHF
        for k=1:4
            if(X(i,k)~=0)
                if(xinit(X(i,k))==0)
                    dot(i,j)=dot(i,j)+A(j,(X(i,k)));
                else
                    dot(i,j)=dot(i,j)-A(j,(X(i,k)));
                end
            end
        end
        if(dot(i,j)>=(-ref(j)))
            dot(i,j)=1;
        else
            dot(i,j)=0;
        end
        if(dot(i,j)~=querydot(j))
            break;
        end
    end
    if(j==(noHF))
        final=X(i,:);
        break; %%if too optimistic that no collision will occur
    end
end 

[guesses,temp] =size(final);
fprintf('\nCode gives best %d guesses and their position of changes are : ',guesses);

final
toc;
clear tic;
