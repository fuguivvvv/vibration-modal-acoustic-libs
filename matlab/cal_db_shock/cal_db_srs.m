function [db,F1,F2,S1,S2]=cal_db_srs(db,F1,F2,S1,S2)
% db=10*log10(S2/S1)/log2(F2/F1);

flag=[isa(db,'char'),isa(F1,'char'), isa(F2,'char'),isa(S1,'char'),isa(S2,'char')];

sum(flag)

if sum(flag)==1  %求解db
    
    if(strcmp(db,'?'))
        db=20*log10(S2/S1)/log2(F2/F1);
    end
    
    if(strcmp(F1,'?'))
        F1=F2/2^(20/db*log10(S2/S1));
    end
    if(strcmp(F2,'?'))
        F2=F1*2^(20/db*log10(S1/S1));
    end
    
    if(strcmp(S1,'?'))
        S1=S2*10^(-1*db/20*log2(F2/F1));
    end
    
    if(strcmp(S2,'?'))
        S2=S1*10^(log2(F2/F1)*db/20);
    end
else
    error('cal_db_srs 参数输入有错误！');
end
end
