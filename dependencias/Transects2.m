classdef  Transects2
    properties
        RefShore
        xin
        yin
        xof
        yof
    end
    methods
        function obj = init(obj,Ref,dy,LenTRS)%,lenTRS
            obj.RefShore=Ref;
            nTRS=floor(obj.RefShore.len/dy);
%             res=obj.len-floor(obj.RefShore.len);
%             a=-1/obj.RefShore.p(1);
            dist=(0:dy:nTRS*dy)';
            resid = @(x) dist - sqrt((obj.RefShore.xi-x).^2+...
                (obj.RefShore.yi-obj.RefShore.pol1d(x)).^2);

%             obj.xin=gmres(resid,d);

            obj.xin = fsolve(resid,repmat(obj.RefShore.xi,...
                [numel(dist),1]));
            obj.yin = obj.RefShore.pol1d(obj.xin);
            
            m = -1/obj.RefShore.p(1);
            c = obj.RefShore.p(2) - LenTRS * sqrt(obj.RefShore.p(1)^2+1);

            
            resid2 = @(x) m .* (x - obj.xin) + obj.yin ...
                - (obj.RefShore.p(1) .* x + c);

            obj.xof = fsolve(resid2,obj.xin);
            obj.yof = obj.RefShore.p(1) .* obj.xof + c;

        end
    end
end
