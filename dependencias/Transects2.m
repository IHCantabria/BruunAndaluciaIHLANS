classdef  Transects2
    properties
        RefShore
        xin;
    end
    methods
        function obj = init(obj,Ref,dy)%,lenTRS
            obj.RefShore=Ref;
            nTRS=floor(obj.RefShore.len/dy);
%             res=obj.len-floor(obj.RefShore.len);
%             a=-1/obj.RefShore.p(1);
            d=(0:dy:nTRS*dy)';
            resid = @(x) sqrt((obj.RefShore.xi-x).^2+...
                (obj.RefShore.yi-obj.RefShore.pol1d(x)).^2);

            obj.xin=gmres(resid,d);
%             obj.yin=
        end
    end
end
