classdef classMyVibrationTimeHis< DataProcessBase
    %   绘制 噪声 时域曲线和dB
    %   Detailed explanation goes here
    properties
        x=0;
        t=0;
        %         fs=0;
        x_rms=0;
        t_rms=0;
        %         channelName='请填写通道名称';
        delt_n=0;
        class_nargin=0;
        t_start=0;
        t_end=0;
        x_lim
        
        
    end
    methods
        function obj=classMyVibrationTimeHis(x,t,channelName,delt_n,t_start,t_end)
            x=x-mean(x(1:200));   %%%%%%去直流
                        
            obj.fs= 1/(t(2)-t(1));
            
            %             x=x-mean(x(1:obj.fs*2));
            
            
            switch nargin
                case 0
                    obj.class_nargin=0;
                case 4
                    obj.class_nargin=4;
                    obj.x=x;
                    obj.t=t;
                    obj.channelName=channelName;
                    obj.delt_n=delt_n;
                case 6
                    obj.class_nargin=6;
                    obj.t_start=t_start;
                    obj.t_end=t_end;
                    ind_t=find(t>=t_start & t<=t_end);
                    obj.x=x(ind_t);
                    obj.t=t(ind_t);
                    obj.channelName=channelName;
                    obj.delt_n=delt_n;
                    
                    Data=obj.x;
                    time=obj.t;
                    [obj.x_rms,obj.t_rms]=myCalRMS(Data,time,delt_n);
                    
            end
            
        end
        function draw(obj)
%                          [obj.t_rms,obj.x_rms]=draw_timeHis_with_rms(obj.x,obj.t,obj.channelName,obj.delt_n); %只画时域曲线和rms
            %                         [obj.t_rms,obj.x_rms]=draw_timeHis_with_rms_zhuanSu_youMenDianYa(obj.x,obj.t,obj.channelName,obj.delt_n);%只画时域曲线、rms、转速、电压
%                                    [obj.t_rms,obj.x_rms]=draw_timeHis_with_rms_zhuanSu_youMenDianYa_gaoDu(obj.x,obj.t,obj.channelName,obj.delt_n);%只画时域曲线、rms、转速、电压、高度
            [obj.t_rms,obj.x_rms]=draw_timeHis_with_rms_zhuanSu(obj.x,obj.t,obj.channelName,obj.delt_n);%只画时域曲线、rms、转速
        end
        
        function drawTimeOnly(obj)
            draw_timeHisOnly(obj.x,obj.t,obj.channelName);
        end
        
        function drawMaxVolcity(obj,frelim1,frelim2)
            
            freLimMin1=frelim1(1);
            freLimMax1=frelim1(2);
            freLimMin2=frelim2(1);
            freLimMax2=frelim2(2);
            
            N=floor(length(obj.x)/obj.delt_n);
            
            N_start=1;
            N_end=N_start+obj.delt_n-1;
            t_VolicityMax=zeros(N,1);
            volicityMax1=zeros(N,1);
            volicityMax2=zeros(N,1);
            
            for i=1:N
                
                NFFT=2048;  %每帧FFT的点数
                t_start=obj.t(N_start);
                t_end=obj.t(N_end);
                
                myFFT_obj=classMyFFT(obj.x,obj.t,obj.fs,obj.channelName,NFFT,t_start,t_end);%平均，按照NFFT分段，重叠比例0.5（在classMyFFT类中定义）
                %     myFFT_obj=classMyFFT(x,t,fs,channeName{i});%不平均
                
                
                myFFT_obj.Y=myFFT_obj.Y(1:length(myFFT_obj.fre))*9.8./(2*pi*myFFT_obj.fre); %加速度谱转化为速度谱
                
                index1=find(myFFT_obj.fre>=freLimMin1 & myFFT_obj.fre<=freLimMax1 );
                t_VolicityMax(i)=obj.t(N_start+obj.delt_n/2-1);
                volicityMax1(i)=max(myFFT_obj.Y(index1));
                freMax1(i)=myFFT_obj.fre(find(myFFT_obj.Y==volicityMax1(i)));
                
                index2=find(myFFT_obj.fre>=freLimMin2 & myFFT_obj.fre<=freLimMax2 );
                volicityMax2(i)=max(myFFT_obj.Y(index2));
                freMax2(i)=myFFT_obj.fre(find(myFFT_obj.Y==volicityMax2(i)));
                
                N_start=N_start+obj.delt_n;
                N_end=N_start+obj.delt_n-1;
            end
            
            save('data.mat','t_VolicityMax','volicityMax1','volicityMax2')
            
            subplot(5,1,1);
            
            plot(obj.t,obj.x);
            grid on;
            title('时域曲线');
            
            subplot(5,1,2);
            grid on;
            %             semilogy(t_VolicityMax,freMax1);
            plot(t_VolicityMax,freMax1);
            title('最大速度的频率');
            
            
            subplot(5,1,3);
            grid on;
            semilogy(t_VolicityMax,volicityMax1);
            title('最大速度');
            
            subplot(5,1,4);
            grid on;
            %             semilogy(t_VolicityMax,freMax2);
            plot(t_VolicityMax,freMax2);
            title('最大速度的频率');
            
            
            subplot(5,1,5);
            grid on;
            semilogy(t_VolicityMax,volicityMax2);
            title('最大速度');
            
        end
        
        function calRmsHis(obj)
            Data=obj.x;
            time=obj.t;
            [rmsData,rmsT]=myCalRMS(Data,time,obj.delt_n);
            obj.x_rms=rmsData;
            obj.t_rms=rmsT;
        end
        
        
        function drawTimehisRmsZhuansu(obj,zhuanSu)
            
            obj.calRmsHis;
            
            subplot(3,1,1);
            
            plot(obj.t,obj.x);
            grid on;
            % set(gca,'XLim',xlim);
            % set(gca,'YLim',ylim);
            title( {obj.channelName  ; '振动时域曲线'});
            ylabel(' (g)   ');
            xlim(obj.x_lim);
            xlabel('时间(s)');                       
            
            subplot(3,1,2);            
            plot(obj.t_rms,obj.x_rms);
            ylabel('（g）');
            title('振动加速度均方根');
            grid on;
            xlim(obj.x_lim);
            xlabel('时间(s)');
            
            subplot(3,1,3);
            plot(zhuanSu.t,zhuanSu.x);
            grid on;
            ylabel('（rpm）');
            title('发动机转速');
            xlim(obj.x_lim);
            xlabel('时间(s)');            
            set(gcf,'Position',[ 200 200 800 600]);
            
            
        end
        
        
        function save(obj)
            declareGlobalVars
            if ~(strcmp(obj.channelName,'请填写通道名称'))
                %                 fileName=['timeHis&rms ' obj.channelName ];
                fileName=[globalResultsPath '\timeHis ' obj.channelName  ' from '  num2str(obj.t_start) 's to ' num2str(obj.t_end) 's'];
                
                %                 cd('./程序结果文件夹');
                
                %                 save([fileName '.mat'],'obj');
                %                 print(gcf,'-dmeta',[fileName '.emf']);
                
                saveas(gcf,[fileName '.fig'],'fig');
                %                 cd ..
            else
                msgbox '保存数据前必须初始化channelName ';
            end
            %             pause(2);
            close all;
            
        end
    end
end

