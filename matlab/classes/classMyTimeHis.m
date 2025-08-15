classdef classMyTimeHis<handle
    %   绘制 噪声 时域曲线和dB
    %   Detailed explanation goes here
    properties
        x=0;
        t=0;
        fs=0;
        x_dB=0;
        t_dB=0;
        x_rms=0;
        t_rms=0;
        channelName='请填写通道名称';
        delt_n=0;
        class_nargin=0;
        flag_dB_rms='';
        fc=[10 2000];
        method='bandpass';
    end
    methods
        function obj=classMyTimeHis(x,t,channelName,delt_n,fc,fs)
            x=x-mean(x(1:200));   %%%%%%去直流
            switch nargin
                case 4
                    obj.class_nargin=4;
                    obj.x=x;
                    obj.t=t;
                    obj.channelName=channelName;
                    obj.delt_n=delt_n;
                    
                case 6 % 滤波
                    obj.class_nargin=6;                    
                    obj.t=t;
                    obj.fc=fc;
                    obj.channelName=channelName;
                    obj.delt_n=delt_n;      
                    method=obj.method;
                    
                    N=4;
                    obj.x=myFiltfilt(x,fs,N,fc,method);                                      
                    
            end
        end
        function drawDB(obj)
            [obj.t_dB,obj.x_dB]=draw_dB_with_timeHis(obj.x,obj.t,obj.channelName,obj.delt_n);
            obj.flag_dB_rms='dB';
        end
        function drawRms(obj)
            [obj.t_rms,obj.x_rms]=draw_timeHis_with_rms(obj.x,obj.t,obj.channelName,obj.delt_n);
            obj.flag_dB_rms='rms';
        end       
        function calRms(obj)
            [obj.x_rms,obj.t_rms]=myCalRMS(obj.x,obj.t,obj.delt_n);
        end        
        function drawTimeHis(obj)
            plot(obj.t,obj.x);
            hold on ;
            
            grid on;
            % set(gca,'XLim',xlim);
            % set(gca,'YLim',ylim);
            title(  {obj.channelName ; '时域曲线' });
            ylabel(' 振动加速度(g)   ');
            xlabel('时间(s)');          
            
        end
    end
end

