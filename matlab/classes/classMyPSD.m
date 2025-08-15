classdef classMyPSD<handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x=0;
        fs=0;
        nfft=0;
        t=0;
        t_start=0;
        t_end=0;
        
        fre_start=0;
        fre_end=0;
        
        f=0;
        PSD=0;
        rms=0;
        channelName='����дͨ������';
        
        tiaoJian_fre=0;
        tiaoJian_PSD=0;
        tiaoJian_rms=0;
        
        class_nargin=0;
        
    end
    
    methods
        function obj=classMyPSD(x,fs,nfft,t,t_start,t_end,fre_start,fre_end,channelName,tiaoJian_fre,tiaoJian_PSD,tiaoJian_rms)
            
            switch nargin
                case 0
                    obj.class_nargin=0;
                case 3
                    obj.x=x;
                    obj.fs=fs;
                    obj.nfft=nfft;
                    obj.t_start=0;
                    obj.t_end=(length(x)-1)*fs;
                    obj.class_nargin=3;                    
                    
                    window=hanning(nfft);
                    noverlap=0.5*nfft;
                    [obj.PSD,obj.f]=pwelch(x,window,noverlap,nfft,fs);
               %      obj.rms=sqrt(trapz(obj.f,obj.PSD));
                   obj.rms=calRMS_interp(obj.f,obj.PSD);
                    
                    obj.fre_start=min(obj.f);
                    obj.fre_end=max(obj.f);
                case 4
                    obj.x=x;
                    obj.fs=fs;
                    obj.nfft=nfft;
                    obj.t=t;
                    obj.t_start=t(1);
                    obj.t_end=t(end);
                    
                    obj.class_nargin=4;
                    
                    window=hanning(nfft);
                    noverlap=0.5*nfft;
                    [obj.PSD,obj.f]=pwelch(x,window,noverlap,nfft,fs);
%                      obj.rms=sqrt(trapz(obj.f,obj.PSD));
                   obj.rms=calRMS_interp(obj.f,obj.PSD);
                    
                    obj.fre_start=min(obj.f);
                    obj.fre_end=max(obj.f);
                    
                case 6
                    obj.t_start=t_start;
                    obj.t_end=t_end;
                    
                    ind_t=find(t>=t_start & t<=t_end);
                    
                    obj.x=x(ind_t);
                    obj.t=t(ind_t);
                    
                    obj.fs=fs;
                    obj.nfft=nfft;
                    obj.class_nargin=6;
                    
                    window=hanning(nfft);
                    noverlap=0.5*nfft;
                    [obj.PSD,obj.f]=pwelch(x(ind_t),window,noverlap,nfft,fs);
                    obj.rms=sqrt(trapz(obj.f,obj.PSD));
                  %   obj.rms=calRMS_interp(obj.f,obj.PSD);
                    
                    obj.fre_start=min(obj.f);
                    obj.fre_end=max(obj.f);
                case 8
                    obj.t_start=t_start;
                    obj.t_end=t_end;
                    
                    ind_t=find(t>=t_start & t<=t_end);
                    
                    obj.x=x(ind_t);
                    obj.t=t(ind_t);
                    
                    obj.fs=fs;
                    obj.nfft=nfft;
                    
                    obj.class_nargin=8;
                    
                    window=hanning(nfft);
                    noverlap=0.5*nfft;
                    [obj.PSD,obj.f]=pwelch(x(ind_t),window,noverlap,nfft,fs);
                    ind_fre=find(obj.f>= fre_start & obj.f<=fre_end);
                   obj.rms=sqrt(trapz(obj.f(ind_fre),obj.PSD(ind_fre)));
                  %    obj.rms=calRMS_interp(obj.f(ind_fre),obj.PSD(ind_fre));
                    
                    obj.fre_start=fre_start;
                    obj.fre_end=fre_end;
                case 9
                    obj.t_start=t_start;
                    obj.t_end=t_end;
                    
                    ind_t=find(t>=t_start & t<=t_end);
                    
                    obj.x=x(ind_t);
                    obj.t=t(ind_t);
                    
                    obj.fs=fs;
                    obj.nfft=nfft;
                    
                    obj.channelName=channelName;
                    
                    obj.class_nargin=9;
                    
                    window=hanning(nfft);
                    noverlap=0.5*nfft;
                    [obj.PSD,obj.f]=pwelch(x(ind_t),window,noverlap,nfft,fs);
                    ind_fre=find(obj.f>= fre_start & obj.f<=fre_end);
                     obj.rms=sqrt(trapz(obj.f(ind_fre),obj.PSD(ind_fre)));
                  %  obj.rms=calRMS_interp(obj.f(ind_fre),obj.PSD(ind_fre));
                    
                    obj.fre_start=fre_start;
                    obj.fre_end=fre_end;
                case 12
                    obj.t_start=t_start;
                    obj.t_end=t_end;
                    
                    ind_t=find(t>=t_start & t<=t_end);
                    
                    obj.x=x(ind_t);
                    obj.t=t(ind_t);
                    
                    obj.fs=fs;
                    obj.nfft=nfft;
                    
                    obj.channelName=channelName;
                    
                    obj.tiaoJian_fre=tiaoJian_fre;
                    obj.tiaoJian_PSD=tiaoJian_PSD;
                    obj.tiaoJian_rms=tiaoJian_rms;
                    
                    obj.class_nargin=12;
                    
                    window=hanning(nfft);
                    noverlap=0.5*nfft;
                    [obj.PSD,obj.f]=pwelch(x(ind_t),window,noverlap,nfft,fs);
                    ind_fre=find(obj.f>= fre_start & obj.f<=fre_end);
                    
                    obj.rms=sqrt(trapz(obj.f(ind_fre),obj.PSD(ind_fre)));                    

%                      obj.rms=calRMS_gongShi(trapz(obj.f(ind_fre),obj.PSD(ind_fre)));
                    
                %     obj.rms=calRMS_interp(obj.f(ind_fre),obj.PSD(ind_fre));
                    
                    obj.fre_start=fre_start;
                    obj.fre_end=fre_end;
                    
            end
            
        end
        
        function draw(obj)
            
            subplot(2,1,1);
            plot(obj.t,obj.x);
            set(gca,'XLim',[obj.t_start obj.t_end]);
            xlabel('ʱ��(s)');
            ylabel({'��' '��'  '��' '(g)'},'Rotation',0,'VerticalAlignment','middle','Fontsize',6);
            title(strcat(obj.channelName,'-ʱ������'));
            grid on;
            subplot(2,1,2);
            loglog(obj.f,obj.PSD);
            hold on;
            loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD,'LineWidth',1.3,'color','red');
            
%             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD*10^(-3/10),'LineWidth',1.3,'color','green');%����3dB����
%             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD*10^(3/10),'LineWidth',1.3,'color','green');
            
            set(gca,'XLim',[obj.fre_start obj.fre_end]);
            set(gca,'YLim',[min(obj.PSD)*0.001 max([obj.PSD' obj.tiaoJian_PSD])*100]);
          %   set(gca,'YLim',[0.00002 max([obj.PSD' obj.tiaoJian_PSD])*100]);
            
            xlabel('Ƶ��(Hz)');
            ylabel({'PSD'  '(g^2/Hz)'},'Rotation',0,'VerticalAlignment','middle','Fontsize',6);
            title(strcat(obj.channelName,'-�������ܶ�'));
            
            grid on ;
            if obj.class_nargin <12
                legend(['�������� Grms=',num2str(obj.rms,'%7.3f') 'g'],'Location','NorthWest');
                
                 
            elseif obj.class_nargin==12
                %                 legend(['�������� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�񶯻������� Grms=' num2str(obj.tiaoJian_rms) 'g'],'Location','NorthWest');
                legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�������� Grms=' num2str(obj.tiaoJian_rms,'%7.2f') 'g'],'Location','SouthWest');
%                 legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�������� Grms=' num2str(obj.tiaoJian_rms,'%7.2f') 'g'],['��3dB����'],'Location','SouthWest'); %����3dB����
                

                
            end
            
            %             legend(strcat('�������� Grms=',num2str(rms,'%7.3f')),['������ Grms=' num2str(tiaoJian_rms) 'g'],'Location','NorthWest');
            
            
        end
        
        function drawPSDOnly(obj)
            
            loglog(obj.f,obj.PSD);
            hold on;
            loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD,'LineWidth',1.3,'color','red');
            
%             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD*10^(-3/10),'LineWidth',1.3,'color','green');%����3dB����
%             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD*10^(3/10),'LineWidth',1.3,'color','green');
            
            set(gca,'XLim',[obj.fre_start obj.fre_end]);
            set(gca,'YLim',[min(obj.PSD)*0.001 max([obj.PSD' obj.tiaoJian_PSD])*100]);
            
            xlabel('Ƶ��(Hz)');
            ylabel({'PSD'  '(g^2/Hz)'},'Rotation',0,'VerticalAlignment','middle','Fontsize',6);
            title(strcat(obj.channelName,'-�������ܶ�'));
            
            grid on ;
            if obj.class_nargin <12
                legend(['�������� Grms=',num2str(obj.rms,'%7.3f') 'g'],'Location','NorthWest');                
                 
            elseif obj.class_nargin==12
                %                 legend(['�������� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�񶯻������� Grms=' num2str(obj.tiaoJian_rms) 'g'],'Location','NorthWest');
                legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�������� Grms=' num2str(obj.tiaoJian_rms,'%7.2f') 'g'],'Location','SouthWest');
%                 legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�������� Grms=' num2str(obj.tiaoJian_rms,'%7.2f') 'g'],['��3dB����'],'Location','SouthWest'); %����3dB����
                                
            end
            
            %             legend(strcat('�������� Grms=',num2str(rms,'%7.3f')),['������ Grms=' num2str(tiaoJian_rms) 'g'],'Location','NorthWest');
            
            
        end
        
        
        
        function save(obj)
            declareGlobalVars;
            if ~(strcmp(obj.channelName,'����дͨ������'))
                fileName=[globalResultsPath '\PSD&ʱ������ ' obj.channelName ' from ' num2str(obj.t_start) 's to ' num2str(obj.t_end) 's'];
                fileNameMat=[globalResultsPath '\PSD- ' obj.channelName ' from ' num2str(obj.t_start) 's to ' num2str(obj.t_end) 's'];
                %                 cd('./�������ļ���');
                %                 save([fileName '.mat'],'obj');
                %                 f=obj.f
                %                 psd=obj.PSD;
                
                %                 save([fileNameMat '.mat'],'f','psd');
                
                %                 print(gcf,'-dmeta',[fileName '.emf']);
                
                                saveas(gcf,[fileName '.fig'],'fig');
                %                 cd ..;
            else
                msgbox '��������ǰ�����ʼ��channelName ';
            end
%             close all;
        end
        
    end
    
    
end

