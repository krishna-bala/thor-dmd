close all

% Speed of the saved video, e.g 3x real time
% Amount of skipped frames to accelerate the rendering

speed = 30;
frame_skip = 160;
body_id_pos = [];

for exp_id = 2:2
    for round_id = 1:length(exp{exp_id})
        close all
        clear M
        figure
        hold on
        axis equal
        axis([-8000,10000,-6000,10000])
        legend('Obstacle','Helmet 1','Helmet 2','Helmet 3','Helmet 4','Helmet 5','Helmet 6','Helmet 7','Helmet 8','Helmet 9','Helmet 10','Velodyne','Citi','Location','northwest')
        frame_counter = 1;
        for t = 1:frame_skip:size(exp{exp_id}{round_id}.RigidBodies.Positions,3)
            plotMap(obst_x,obst_y,exp_id)
            rectangle('Position',[1800 -5600 7800 1200],'FaceColor',[1 1 1])
            text(2000, -5000, strcat('Frame-', int2str(t)),'FontWeight','bold','FontSize',16,'Color',[0,0,0])
            for body_id = 2:13
                pos = exp{exp_id}{round_id}.RigidBodies.Positions(body_id,1:2,t);
                if(isnan(pos))
                    pos = [19999,19999];
                end
                body_id_pos(2*((round_id*body_id)-2)+1,(t+frame_skip-1)/frame_skip) = pos(1);
                body_id_pos(2*((round_id*body_id)-2)+2,(t+frame_skip-1)/frame_skip) = pos(2);
                plot(pos(1),pos(2),'.','MarkerSize',30,'Color',body_colors(body_id,:))
                if(body_id<12)
                    text(pos(1),pos(2),int2str(body_id-1))
                end
                hold on
            end
            
            legend('Obstacle','Helmet 1','Helmet 2','Helmet 3','Helmet 4','Helmet 5','Helmet 6','Helmet 7','Helmet 8','Helmet 9','Helmet 10','Velodyne','Citi','Location','northwest')
            M(frame_counter) = getframe;
            frame_counter = frame_counter + 1;
            pause(0.000001)
            clf
            hold on
            axis equal
            axis([-8000,10000,-6000,10000])
        end

        M(1) = []
        filename = strcat(cd,'/exp_',int2str(exp_id),'-',int2str(round_id),'updated.avi');
        myVideo = VideoWriter(filename);
        myVideo.FrameRate = round(100*speed/frame_skip);
        myVideo.Quality = 85;
        open(myVideo);
        writeVideo(myVideo, M);
        close(myVideo);
    
    end
end