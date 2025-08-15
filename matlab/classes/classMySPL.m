classdef classMySPL<handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x=0;
        t=0; 
        t_start=0;
        t_end=0;
        fs=0;
        nfft=0;
        fre_start=0;
        fre_end=0;
        f=0;
        s=0;
        channelName='请填写通道名称';
        tiaoJian_dB=0;
        fre3rd=0;
        spl=0;
        ospl=0;
        splToDraw=0;
        tiaoJianToDraw=0;
        class_nargin=0;
    end
    
    methods
        function obj=classMySPL(x,t,t_start,t_end,fs,nfft,fre_start,fre_end,channelName,tiaoJian_dB)
            switch nargin
                case 0
                    obj.class_nargin=0;
                case 10
                    obj.class_nargin=10;
                    ind_t=find(t>=t_start & t<=t_end);
                    obj.x=x(ind_t);
                    obj.t=t(ind_t);
                    obj.fs=fs;
                    obj.nfft=nfft;
                    obj.t_start=t_start;
                    obj.t_end=t_end;
                    obj.fre_start=fre_start;
                    obj.fre_end=fre_end;
                    obj.channelName=channelName;
                    obj.tiaoJian_dB=tiaoJian_dB;
            end
        end
        function drawSPL(obj)
            [obj.fre3rd,obj.spl,obj.ospl,obj.splToDraw,obj.tiaoJianToDraw]=draw_SPL_with_timeHis(obj.x,obj.t,obj.t_start,obj.t_end,obj.fs,obj.nfft,obj.fre_start,obj.fre_end,obj.channelName,obj.tiaoJian_dB);
            
        end
        
        function save(obj)
            if ~(strcmp(obj.channelName,'请填写通道名称'))
                fileName=['SPL&时域曲线 ' obj.channelName ' from ' num2str(obj.t_start) 's to ' num2str(obj.t_end) 's'];
                cd('./程序结果文件夹');
                save([fileName '.mat'],'obj');
                print(gcf,'-dmeta',[fileName '.emf']);
                saveas(gcf,[fileName '.fig'],'fig');
                cd ..
            else
                msgbox '保存数据前必须初始化channelName ';
            end
            close all;
        end
    end
    
end

