classdef classMySRS<handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
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
        channelName='请填写通道名称';
        tiaoJian_fre1=0;
        tiaoJian_SRS1=0;
        tiaoJianName1='';
        tiaoJian_fre2=0;
        tiaoJian_SRS2=0;
        tiaoJianName2='';
        
        class_nargin=0;
        TE=0;
        Te=0;
    end
    
    methods
        function obj=classMySRS(x,fs,t,t_start,t_end,fre_start,fre_end,channelName,tiaoJian_fre1,tiaoJian_SRS1,tiaoJianName1,tiaoJian_fre2,tiaoJian_SRS2,tiaoJianName2)
            switch nargin
                case 0
                    obj.class_nargin=0;
                case 8
                    obj.class_nargin=8;
                    
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
                    
                    [s,f]=srsa(obj.x,fs,fmin,fmax,12,1);
                    
                    %                     plot(obj.x)
                    draw_SRS_with_timeHis(obj.x,obj.t,fs,s,f,fmin,fmax,channelName);

                    obj.f=f;
                    obj.s=s;
                    
                case 11
                    obj.class_nargin=11;
                    
                    ind_t=find(t>=t_start & t<=t_end);
                    
                    obj.x=x(ind_t);
                    obj.t=t(ind_t);
                    obj.fs=fs;
                    obj.t_start=t_start;
                    obj.t_end=t_end;
                    obj.fre_start=fre_start;
                    obj.fre_end=fre_end;
                    obj.channelName=channelName;
                    
                    obj.tiaoJian_fre1=tiaoJian_fre1;
                    obj.tiaoJian_SRS1=tiaoJian_SRS1;
                    obj.tiaoJianName1=tiaoJianName1;
                    
                    fmin=fre_start;
                    fmax=fre_end;
                    [s,f]=srsa(obj.x,fs,fmin,fmax,12,1);
                    obj.f=f;
                    obj.s=s;
                    draw_SRS_with_timeHis(obj.x,obj.t,fs,s,f,fmin,fmax,channelName,tiaoJian_fre1,tiaoJian_SRS1,tiaoJianName1);
                    
                case 14
                    obj.class_nargin=14;
                    
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
                    
                    obj.tiaoJian_fre1=tiaoJian_fre1;
                    obj.tiaoJian_SRS1=tiaoJian_SRS1;
                    obj.tiaoJianName1=tiaoJianName1;
                    obj.tiaoJian_fre2=tiaoJian_fre2;
                    obj.tiaoJian_SRS2=tiaoJian_SRS2;
                    obj.tiaoJianName2=tiaoJianName2;
                    
                    [s,f]=srsa(obj.x,fs,fmin,fmax,12,1);
                    obj.f=f;
                    obj.s=s;
                    draw_SRS_with_timeHis(obj.x,obj.t,fs,s,f,fmin,fmax,channelName,tiaoJian_fre1,tiaoJian_SRS1,tiaoJianName1,tiaoJian_fre2,tiaoJian_SRS2,tiaoJianName2);
            end

            [obj.TE,obj.Te]=calTE(obj.x,obj.fs);
        end
        
        function save(obj)
            declareGlobalVars;
            if ~(strcmp(obj.channelName,'请填写通道名称'))
                fileName=[globalResultsPath '\SRS&时域曲线 ' obj.channelName ' from ' num2str(obj.t_start) 's to ' num2str(obj.t_end) 's'];
                %                 cd('./程序结果文件夹');
                %                 save([fileName '.mat'],'obj');
                %                 print(gcf,'-dmeta',[fileName '.emf']);
                saveas(gcf,[fileName '.fig'],'fig');
                %                 cd ..
            else
                msgbox '保存数据前必须初始化channelName ';
            end
            close all;
        end
        
        
        function modify_dipin_s(obj,fre ,factor1,facor2)
            
            
            index=obj.f<=fre;
            factor1=factor1;
            factor2=facor2;
            %低频修正
            obj.s(index)=line_factor(obj.s(index),obj.f(index),factor1,factor2);
            
        end
                
        
    end
    
    
    
end

