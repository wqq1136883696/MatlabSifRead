function [pattern,calibvals,data,xtype,xunit,ytype,yunit] = MatlabUI_sif_show(path)
%   读取sif文件的函数
%
%   pattern=0为信号模式,输出横坐标calibvals,和纵坐标data，使用plot(calibvals,data); 
%
%   pattern=4为图像模式,输出数据data,使用imagesc(data)可以显示成像
%
rc=atsif_setfileaccessmode(0);
rc=atsif_readfromfile(path);
if (rc == 22002)
  signal=0;
  [rc,present]=atsif_isdatasourcepresent(signal);
  if present
    [rc,no_frames]=atsif_getnumberframes(signal);
    if (no_frames > 0)
        [rc,size]=atsif_getframesize(signal);
        [rc,left,bottom,right,top,hBin,vBin]=atsif_getsubimageinfo(signal,0);
        xaxis=0;
        [rc,data]=atsif_getframe(signal,0,size);
        [rc,pattern]=atsif_getpropertyvalue(signal,'ReadPattern');
        if(pattern == '0')
           calibvals = zeros(1,size);
           for i=1:size,[rc,calibvals(i)]=atsif_getpixelcalibration(signal,xaxis,(i)); 
           end 
%            显示信号图像
%            plot(calibvals,data);      
%            title('spectrum');
           [rc,xtype]=atsif_getpropertyvalue(signal,'XAxisType');
           [rc,xunit]=atsif_getpropertyvalue(signal,'XAxisUnit');
           [rc,ytype]=atsif_getpropertyvalue(signal,'YAxisType');
           [rc,yunit]=atsif_getpropertyvalue(signal,'YAxisUnit');
%            xlabel({xtype;xunit});
%            ylabel({ytype;yunit});
        elseif(pattern == '4')
            width = ((right - left)+1)/hBin;
            height = ((top-bottom)+1)/vBin;
            calibvals = zeros(1,width);
           data=reshape(data,width,height);
           xtype = 'Pixel Number';
           ytype = 'Pixel Number';
           xunit = 0;
           yunit = 0;
           % 显示图像
%            imagesc(data);
        end
    end    
  end
  atsif_closefile;
else
  disp('Could not load file.  ERROR - ');
  disp(rc);
end

end