classdef  ReferenceSL
    properties
        xi
        yi
        xf
        yf
        pol1d
        len
        p
    end
    methods
        function obj=init(obj,xi,yi,xf,yf)
            obj.xi=xi;
            obj.yi=yi;
            obj.xf=xf;
            obj.yf=yf;
            obj.p=polyfit([xi,xf],[yi,yf],1);
            obj.pol1d=@(x) obj.p(1).*x + obj.p(2);
            obj.len=sqrt((obj.xi-obj.xf)^2+(obj.yi-obj.yf)^2);
        end
    end
end