classdef classMyAcousticTimeHis<handle
    %   绘制 噪声 时域曲线和dB
    %   Detailed explanation goes here
    properties
        x=0;
        t=0;
        fs=25600;
        x_dB=0;
        t_dB=0;
        channelName='请填写通道名称';
        delt_n=0;
        class_nargin=0;
    end
    methods
        function obj=classMyAcousticTimeHis(x,t,channelName,delt_n,t_start,t_end,fs)
            x=x-mean(x(1:100));   %%%%%%去直流
            obj.fs= fs;
            %             [b,a]=butter(14,[50 10000]/(obj.fs/2));%%%%%%滤波
            [b,a]=butter(3,[44 11225]/(obj.fs/2));%%滤波
            
            %             [b,a]=butter(10,50/(obj.fs/2),'high');%%%%%%高通滤波
           x=filter(b,a,x);
                       
            switch nargin
                case 0
                    obj.class_nargin=0;
                case 4
                    obj.class_nargin=4;
                    obj.x=x;
                    obj.t=t;
                    obj.channelName=channelName;
                    obj.delt_n=delt_n;
                case 7
                    obj.class_nargin=6;
                    ind_t=find(t>=t_start & t<=t_end);
                    obj.x=x(ind_t);
                    obj.t=t(ind_t);
                    obj.channelName=channelName;
                    obj.delt_n=delt_n;
            end
            
        end
        
        
        function draw(obj)
            [obj.t_dB,obj.x_dB]=draw_dB_with_timeHis(obj.x,obj.t,obj.channelName,obj.delt_n);
        end
        
        function save(obj)
            if ~(strcmp(obj.channelName,'请填写通道名称'))
                fileName=['timeHis&rms ' obj.channelName ];
                cd('./程序结果文件夹');
                %                 save([fileName '.mat'],'obj');
                print(gcf,'-dmeta',[fileName '.emf']);
                %saveas(gcf,[fileName '.fig'],'fig');
                cd ..
            else
                msgbox '保存数据前必须初始化channelName ';
            end
            %             pause(2);
            close all;
            
        end
    end
end

