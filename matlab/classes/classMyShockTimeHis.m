classdef classMyShockTimeHis<handle
    %   绘制 噪声 时域曲线和dB
    %   Detailed explanation goes here
    properties
        x=0;
        t=0;
        fs=0;
        TE=0;
        Te=0;
        channelName='请填写通道名称';
        
    end
    methods
        function obj=classMyShockTimeHis(x,t,channelName,t_start,t_end)
            x=x-mean(x(1:200));   %%%%%%去直流
            obj.fs= 1/(t(2)-t(1));
            switch nargin
                
                case 3
                    obj.x=x;
                    obj.t=t;
                    obj.channelName=channelName;
                case 5
                    ind_t=find(t>=t_start & t<=t_end);
                    obj.x=x(ind_t);
                    obj.t=t(ind_t);
                    obj.channelName=channelName;
                    
            end
            [obj.TE,obj.Te]=calTE(x,obj.fs);
            
        end
        function draw(obj)
            plot(obj.t,obj.x);
            
        end
        
        function save(obj)
            if ~(strcmp(obj.channelName,'请填写通道名称'))
                fileName=['timeHis&rms ' obj.channelName ];
                cd('./程序结果文件夹');
                %save([fileName '.mat'],'obj');
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

