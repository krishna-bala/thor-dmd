function writeMat2CSV(matFileLocation, matFileName)

fileID = fopen('experiment_csv.txt','w');

% First we load the mat file.
matFileStruct = load(matFileLocation + matFileName);

% What's the name of the structure element? 
elemName = strtok(matFileName, '.');

pubs = [];
total_observations = size(squeeze(matFileStruct.(elemName).RigidBodies.Positions(1,:,:)),2);

obj1 = ProgressBar(total_observations,'Title', 'Publishing ros messages');

for i = 1:total_observations-1
  for j = 1:13
        
    Translation = matFileStruct.(elemName).RigidBodies.Positions(j,:,i);
    NextTranslation = matFileStruct.(elemName).RigidBodies.Positions(j,:,i+1);
    
    % Convert Translation data to meters from mm.
    Translation = Translation / 1000.00;
    NextTranslation = NextTranslation / 1000.00;
    

    if isnan(Translation(1)) || isnan(Translation(2)) || isnan(Translation(3)) ...
      || isnan(NextTranslation(1)) || isnan(NextTranslation(2)) || isnan(NextTranslation(3))
      continue;
    end
      
   
    speedx = (NextTranslation(1) - Translation(1))/0.01;
    speedy = (NextTranslation(2) - Translation(2))/0.01;
    
    speed = sqrt(speedx * speedx + speedy * speedy);
    theta = atan2(speedy, speedx);
    
    fprintf(fileID, "%f %f %f %f %f %f\n", Translation(1), Translation(2), speedx, speedy, theta, speed);
    
  end
  obj1.step([], [], []);
end
end