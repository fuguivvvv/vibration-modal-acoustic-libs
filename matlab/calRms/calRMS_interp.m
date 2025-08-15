function rms=calRMS_interp(f,w)
% F_inter=min(f):1/1000:max(f);

if f(1)==0
    f(1)=[];
    w(1)=[];
end

F_inter=linspace(min(f),max(f),10000);
F_inter_log=log2(F_inter);

f=turn2ColVector(f);
w=turn2ColVector(w);

fw=[log2(f) log10(w)];
fw=unique(fw,'rows');

% logical_isinf=isinf(fw(:,1));
% index=find(logical_isinf==1);

% fw(index,:)=[];

W_inter_log=interp1(fw(:,1),fw(:,2),F_inter_log);
W_inter=10.^W_inter_log;
rms=sqrt(trapz(F_inter,W_inter));