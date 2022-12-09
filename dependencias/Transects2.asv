classdef  Transects2
    properties
        RefLine
        xin
        yin
        xof
        yof
        p
        nTRS
        nOBS
        Y_obs
        t_obs
        Y_inicial
    end
    methods
        function obj = init(obj,Ref,dy,LenTRS)%,lenTRS
            obj.RefLine=Ref;
            n=floor(Ref.len/dy);

            OutBnd=Ref.len-n*dy;

            dist=(OutBnd/2:dy:n*dy+OutBnd/2)';
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
%             obj.p
            obj.p(:,1) = (obj.yof-obj.yin)./(obj.xof-obj.xin);
            obj.p(:,2) = obj.yin - obj.p(:,1).*obj.xin;

            obj.nTRS=n+1;

        end
        function obj = addSamples(obj, ENS)
            obj.nOBS=size(ENS.Yobs,1);
            yOBS=zeros(obj.nTRS,1);
            xOBS=zeros(obj.nTRS,1);
            obj.Y_obs=zeros(obj.nOBS,obj.nTRS);
            
            H=figure('Position',[10 10 900 600]);
            ax=gca();
            ax.YLim=[min(min(ENS.Y))-400,max(max(ENS.Y))+400];
            ax.XLim=[min(min(ENS.X))-100,max(max(ENS.X))+100];

            for i=1:obj.nOBS
                f_ENS=fit(ENS.X(i,:)',ENS.Y(i,:)','linearinterp');
                resFun=@(x) f_ENS(x) - (obj.p(:,1).*x + obj.p(:,2));
                xOBS = fsolve(resFun,obj.xin);
                yOBS = f_ENS(xOBS);
                
                [YY,MM,DD]=datevec(ENS.time(i));
                
                hold off
                plot(ENS.X(i,:),ENS.Y(i,:),'ko')
                hold on
                plot(xOBS,yOBS,'rx')
                grid; grid minor;
                ax.GridLineStyle='-';
                ax.GridColor='k';
                ax.GridAlpha=.6;
                ax.YLabel.String='Y [UTM]';
                ax.XLabel.String='X [UTM]';
                title([num2str(DD,'%02d'),'/',num2str(MM,'%02d'),'/',num2str(YY,'%04d')])
                legend('Medición','Interpolación',Location='northwest')
                ax.FontWeight='bold';
                ax.FontSize=10;
                
                drawnow
                frame=getframe(H);
                im=frame2im(frame);
                [imind,cm]=rgb2ind(im,256);
                if i==1
                    imwrite(imind,cm,'EvolSL.gif','gif','loopcount', inf);
                else
                    imwrite(imind,cm,'EvolSL.gif','gif','WriteMode','append');
                end
                
                obj.Y_obs(i,:) = sqrt((xOBS-obj.xin).^2+(yOBS-obj.yin).^2)';
            end
            obj.t_obs=ENS.time;
            obj.Y_inicial = obj.Y_obs(1,:)';
        end
    end
end
