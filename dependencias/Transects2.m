classdef  Transects2
    properties
        RefLine
        xin
        yin
        xof
        yof
    end
    methods
        function obj = init(obj,Ref,dy,LenTRS)%,lenTRS
            obj.RefLine=Ref;
            nTRS=floor(Ref.len/dy);

            OutBnd=Ref.len-nTRS*dy;

            dist=(OutBnd/2:dy:nTRS*dy+OutBnd/2)';
            resid = @(x) dist - sqrt((Ref.xi-x).^2+...
                (Ref.yi-Ref.pol1d(x)).^2);

            obj.xin = fsolve(resid,repmat(Ref.xi,...
                [numel(dist),1]));
            obj.yin = Ref.pol1d(obj.xin);
            
            m = -1/Ref.p(1);
            c = Ref.p(2) - LenTRS * sqrt(Ref.p(1)^2+1);

            
            resid2 = @(x) m .* (x - obj.xin) + obj.yin ...
                - (Ref.p(1) .* x + c);

            obj.xof = fsolve(resid2,obj.xin);
            obj.yof = Ref.p(1) .* obj.xof + c;

        end
    end
end
