
for i = 1:12
    for j = 1:5
        Vx = So(1,3,:,i,j);
        Vy = So(1,4,:,i,j);
        Vx_format = Vx(:);
        Vy_format = Vy(:);

        Vx_valid = Vx(find(~isnan(Vx)));
        %Vy_valid = Vy(find(~isnan(Vy)));
        Vx_vformat = Vx_valid(:);
        if ~isempty(Vx_vformat) && length(Vx_vformat) > 1
            V_xy = zeros(size(Vx_format));
        else
            continue
        end
        
        for n = 1:size(Vx_format)
            V_xy(n) = sqrt(Vx_format(n)^2 + Vy_format(n)^2);
        end
        V_xy_s = sgolayfilt(V_xy,1,41);
            
        Tg_stop = Time_indx(:,i,j);
        Tg_stop2 = Tg_stop(~isnan(Tg_stop));
        
        Px = So(1,1,:,i,j);
        Py = So(1,2,:,i,j);
        %Px_valid = Px(find(~isnan(Px)));
        %Py_valid = Py(find(~isnan(Py)));
        Px_format = Px(:);
        Py_format = Py(:);
        
        f = 1:size(V_xy);
        Tg = islocalmin(V_xy_s,'MinSeparation',500,'MinProminence',300);
        for tg = 1:size(V_xy_s)
            if V_xy_s(tg) > 300
                Tg(tg) = 0;
            end
            if ismember(tg,Tg_stop2)
                Tg(tg) = 1;
            end
        end
        figure
        plot(f,V_xy_s,f(Tg),V_xy_s(Tg),'r*')
        hold on
        plot(f,Px_format)
        plot(f,Py_format)
        %plot(f,Vx_format) 
        %plot(f,Vy_format)
        legend
        title(['Participant',num2str(i),'Experiment',num2str(j)])
        hold off
    end
end