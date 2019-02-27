classdef MatlabSifPlot < matlab.apps.AppBase
    %MATLABSIFPLOT �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        number = 1
        pattern         % ��ȡģʽ
        calibvals       % ������
        data            % ����
        xtype           % x������
        xunit           % x�ᵥλ
        ytype           % x������
        yunit           % y�ᵥλ
    end
    
    properties
        % �����������
        allPattern
        allCalibvals       % ������
        allCalibvalsLength % ���ݵĳ���
        allData            % ����
        allXtype  = ""     % x������
        allXunit  = ""     % x�ᵥλ
        allYtype  = ""     % x������
        allYunit  = ""     % y�ᵥλ
        
        allImageData        % ���е�ͼ������
    end
    
    methods (Access = public)
        function obj = MatlabSifPlot()
            %MATLABSIFPLOT ��������ʵ��
            %   �˴���ʾ��ϸ˵��         
        end
        
        function  GetSifData(obj,path)
            %GetSifData ���sif����
            %   path Ϊ�ļ���·��
            charPath = char(path);
            [obj.pattern,obj.calibvals,obj.data,xtype1,xunit1,...
                ytype1,yunit1] = MatlabUI_sif_show(charPath);
            
            obj.xtype = string(xtype1);
            obj.xunit = string(xunit1);
            obj.ytype = string(ytype1);
            obj.yunit = string(yunit1);
            % ��������
            obj.SaveData(obj.number);
            obj.number = obj.number + 1;
        end
        
        % ���źŵ�ͼ��
        function [line,statu] = SignalPlot(obj,uiaxes,calibvals,data,xtype,xunit,ytype)
            % ��signalͼ��number���û���������
            if(uiaxes == 0)
                % ����ͨͼ��
                fig=figure;
                
                line = plot(calibvals,data);
                y_max = max(data);
                size = length(calibvals);
                xlim([calibvals(1) calibvals(size)]);
                ylim([0 y_max*1.05]);
                title('spectrum');
                xlabel({xtype;xunit});
                ylabel({ytype});
                grid on;
                zoom on;
                
                % �����ļ�
                statu = obj.SaveSifToJpg(fig);
                
            else
                % ����UIAxes��
                line = plot(uiaxes,calibvals,data);
                y_max = max(data);
                size = length(calibvals);
                xlim(uiaxes,[calibvals(1) calibvals(size)]);
                ylim(uiaxes,[0 y_max*1.05]);
                title(uiaxes,'spectrum');
                xlabel(uiaxes,{xtype;xunit});
                ylabel(uiaxes,{ytype});
                grid(uiaxes,'on');
                zoom(uiaxes,'on');
                statu = -1;
            end
        end
        
        % ��ʾimageģʽ��ͼ��
        function [im,statu] = ImageShow(obj,uiaxes,data,xtype,ytype)
            % ��imageͼ��number���û���������
            if(uiaxes == 0)
                % ����figure���ڣ�������
                fig = figure;
                theData = data';
                xlim([0 1024]);
                ylim([0 256]);
                im = imagesc(theData);
                title('Image');
                xlabel({xtype});
                ylabel({ytype});
                colorbar();
                zoom on;
                statu = obj.SaveSifToJpg(fig);
            else
                % ����UIAxes����
                theData = data';
                uiaxes.XLim = [0 1024];
                uiaxes.YLim = [0 256];
                im = imagesc(uiaxes,theData);
                title(uiaxes,'Image');
                xlabel(uiaxes,{xtype});
                ylabel(uiaxes,{ytype});
                % colorbar(app.UIAxes);
                zoom(uiaxes,'on');
                statu = -1;
            end
        end
        
        function [ret,statu] = SifPlot(obj,uiaxes,number)
            %  ��ͼ��uiaxes = 0ʱ��ֱ���½�������ʾ��number���û���������
            % ����ֵ�� retΪͼ����� statuΪ�Ƿ񱣴�ͼƬ��-1Ϊû�б���
            if obj.allPattern(:,number) == '0'
                row = obj.allCalibvalsLength(:,number);
                [ret,statu] = SignalPlot(obj,uiaxes,obj.allCalibvals(1:row,number),...
                    obj.allData(1:row,number),obj.allXtype(:,number),...
                    obj.allXunit(:,number),obj.allYtype(:,number));
            elseif obj.allPattern(:,number) == '4'
                 [ret,statu] = ImageShow(obj,uiaxes,obj.allImageData(:,:,number),...
                    obj.allXtype(:,number),obj.allYtype(:,number));
            end
        end
            
        % ����sif���ݳ�ΪͼƬ
        function statu = SaveSifToJpg(obj,fig)
            [f,p]=uiputfile({'*.jpg';'*.png';'*.pdf'},'�����ļ�');
            if(length(f) > 1)
                str=strcat(p,f);
                if(contains(f,'.jpg'))
                    print(fig,str,'-djpeg')
                elseif(contains(f,'.png'))
                    print(fig,str,'-dpng')
                elseif(contains(f,'.pdf'))
                    print(fig,str,'-dpdf')
                end
                statu = 1;
            else
                statu = 0;
            end
        end
        
    end
    
    methods (Access = private)
        % ˽�з���
        function SaveData(obj,number)
            % ����ȫ��������
            % number Ϊ��ֵ����1��ʼ������
            obj.allPattern(:,number) = obj.pattern;
            
            if obj.pattern == '0'
                % �ж��Ƿ�Ϊ����
                [row, col] = size(obj.calibvals);
                if col ~= 1
                    obj.calibvals = (obj.calibvals)';
                    row = col;
                end
                obj.allCalibvals(1:row,number) = obj.calibvals;
                obj.allCalibvalsLength(:,number) = row;
                obj.allData(1:row,number) = obj.data;
                obj.allXtype(:,number) = obj.xtype;
                obj.allXunit(:,number) = obj.xunit;
                obj.allYtype(:,number) = obj.ytype;
                obj.allYunit(:,number) = obj.yunit;
            elseif obj.pattern == '4'
                obj.allImageData(:,:,number) = obj.data;
                obj.allXtype(:,number) = obj.xtype;
                obj.allYtype(:,number) = obj.ytype;
            end
                
        end
        
    end
    
    
end

