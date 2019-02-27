classdef MatlabSifPlot < matlab.apps.AppBase
    %MATLABSIFPLOT 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        number = 1
        pattern         % 读取模式
        calibvals       % 横坐标
        data            % 数据
        xtype           % x轴类型
        xunit           % x轴单位
        ytype           % x轴类型
        yunit           % y轴单位
    end
    
    properties
        % 保存多组数据
        allPattern
        allCalibvals       % 横坐标
        allCalibvalsLength % 数据的长度
        allData            % 数据
        allXtype  = ""     % x轴类型
        allXunit  = ""     % x轴单位
        allYtype  = ""     % x轴类型
        allYunit  = ""     % y轴单位
        
        allImageData        % 所有的图像数据
    end
    
    methods (Access = public)
        function obj = MatlabSifPlot()
            %MATLABSIFPLOT 构造此类的实例
            %   此处显示详细说明         
        end
        
        function  GetSifData(obj,path)
            %GetSifData 获得sif数据
            %   path 为文件的路径
            charPath = char(path);
            [obj.pattern,obj.calibvals,obj.data,xtype1,xunit1,...
                ytype1,yunit1] = MatlabUI_sif_show(charPath);
            
            obj.xtype = string(xtype1);
            obj.xunit = string(xunit1);
            obj.ytype = string(ytype1);
            obj.yunit = string(yunit1);
            % 保存数据
            obj.SaveData(obj.number);
            obj.number = obj.number + 1;
        end
        
        % 画信号的图像
        function [line,statu] = SignalPlot(obj,uiaxes,calibvals,data,xtype,xunit,ytype)
            % 画signal图像，number是用户传进来的
            if(uiaxes == 0)
                % 画普通图窗
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
                
                % 保存文件
                statu = obj.SaveSifToJpg(fig);
                
            else
                % 画到UIAxes中
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
        
        % 显示image模式的图像
        function [im,statu] = ImageShow(obj,uiaxes,data,xtype,ytype)
            % 画image图像，number是用户传进来的
            if(uiaxes == 0)
                % 画到figure窗口，并保存
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
                % 画到UIAxes窗口
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
            %  画图像，uiaxes = 0时就直接新建窗口显示，number是用户传进来的
            % 返回值， ret为图像对象， statu为是否保存图片，-1为没有保存
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
            
        % 保存sif数据成为图片
        function statu = SaveSifToJpg(obj,fig)
            [f,p]=uiputfile({'*.jpg';'*.png';'*.pdf'},'保存文件');
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
        % 私有方法
        function SaveData(obj,number)
            % 保存全部的数据
            % number 为数值，从1开始，递增
            obj.allPattern(:,number) = obj.pattern;
            
            if obj.pattern == '0'
                % 判断是否为单列
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

