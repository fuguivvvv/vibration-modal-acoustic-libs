classdef classMySRS_zheng<handle    
    properties
        x=0;
        t=0;
        fs=0;
        t_start=0;
        t_end=0;
        fre_start=0;
        fre_end=0;
        f=0;
        s=0;
        channelName='ÇëÌîÐ´Í¨µÀÃû³Æ';  
        oct=12;
    end    
    methods
        function obj=classMySRS_zheng(x,fs,t,t_start,t_end,fre_start,fre_end,channelName)
                    
                    ind_t=find(t>=t_start & t<=t_end);                    
                    obj.x=x(ind_t);
                    obj.t=t(ind_t);                    
                    obj.fs=fs;                    
                    obj.t_start=t_start;
                    obj.t_end=t_end;
                    obj.fre_start=fre_start;
                    obj.fre_end=fre_end;                    
                    obj.channelName=channelName;                    
                    fmin=fre_start;
                    fmax=fre_end;                    
                    [s,f]=srsa_zheng(obj.x,fs,fmin,fmax,obj.oct,1);                  
                    obj.f=f;
                    obj.s=s;         
        end
        
    end
    
end

