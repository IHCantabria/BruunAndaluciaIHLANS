classdef  ShoreLines
    properties
        x
        y
        fecha
        x_interp
        y_interp
        p_interp
        orden
        p_ref
        x_ref
        y_ref
        s_ref
        time
        ms
        mn
    end
    methods
        function obj=add_shore(obj,x,y,fechas)
            obj.x=x;
            obj.y=y;
            obj.time=datenum(fechas);
            obj.fecha=fechas;
        end
        function obj=interp_shore(obj,orden)
            obj.orden=orden;
            obj.p_interp = polyfit(obj.x, obj.y, orden);
            obj.x_interp = linspace(min(obj.x),max(obj.x)+100,5000);
            obj.y_interp = polyval(obj.p_interp,obj.x_interp);
        end
        function obj=ref_line(obj)
            obj.p_ref=polyfit(obj.x_interp,obj.y_interp,obj.orden);
            obj.x_ref=min(obj.x_interp):0.1:max(obj.x_interp)+100.1;
            obj.y_ref=polyval(obj.p_ref,obj.x_ref);
            obj.s_ref = [0,cumsum(sqrt((obj.x_ref(2:end)-obj.x_ref(1:end-1)).^2. ...
                + (obj.y_ref(2:end)-obj.y_ref(1:end-1)).^2))];
            pder=polyder(obj.p_ref);
            obj.ms = polyval(pder,obj.x_ref);
            obj.mn = -1./obj.ms;
        end
    end
end