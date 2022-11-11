classdef  Transects
    properties
        ms
        alfas
        ds
        mn
        alfan
%       alfan = np.degrees(np.arctan(self.mn)) + 180 # because of the sea side
        dn 
        Nn
        Ns
        xi
        yi 
        xe 
        ye 
        isbfs = 0;
        x_cross
        y_cross
        n_cross

    end
    methods
        function obj=init(obj,ms,ds,mn,dn,Nn)
            obj.ms=ms;
            obj.alfas=rad2deg(atan(obj.ms));
            obj.ds=ds;
            obj.mn=mn;
            obj.alfan=rad2deg(atan(obj.mn));
            obj.dn=dn;
            obj.Nn=Nn;
        end
        function obj=create_transect(obj,x0,y0)
            obj.xi = x0;
            obj.yi = y0;
            [obj.xe, obj.ye] = pol2cart(obj.dn.*obj.Nn, deg2rad(obj.alfan));
            obj.xe = obj.xi + obj.xe;
            obj.ye =  obj.yi + obj.ye;
        end
        function obj=create_buffer(obj,bfs,dbfs)
            obj.bfs  = bfs;
            obj.dbfs = dbfs;
            obj.dbfsa = linspace(-obj.bfs/2,obj.bfs/2,obj.bfs/obj.dbfs+1);
            obj.wbfs = 1./obj.dbfsa;
            obj.wbfs(isinf(obj.wbfs)) = 1;
            obj.isbfs = 1;
            obj.x_bf = zeros([length(obj.wbfs),2]);
            obj.y_bf = zeros([length(obj.wbfs),2]);
        end
        function obj=create_profile(obj)
            obj.x_cross = zeros([obj.Nn+1,1]);
            obj.y_cross = zeros([obj.Nn+1,1]);
            obj.n_cross = zeros([obj.Nn+1,1]);
            aux=0:obj.Nn;
            obj.n_cross(:,1) = obj.dn.*aux;
            [obj.x_cross(:,1), obj.y_cross(:,1)] = pol2cart(obj.n_cross(:,1), deg2rad(obj.alfan));
            obj.x_cross(:,1) = obj.x_cross(:,1)+obj.xi;
            obj.y_cross(:,1) = obj.y_cross(:,1)+obj.yi;
        end
    end
end
