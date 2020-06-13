%% Compute the instantaneous dip on a 3D cube using the gradient tensor
% Synopsis: [dip,az,p,q,c,x]=gradient_tensor(S); with S seismic, p inline dip
% q crossline dip.
function [dip,az,p,q,c,x]=gradient_tensor(S)
%% Load the 3D seismic cube
[ni,nj,nk]=size(S);

%% initialization
di=zeros(size(S)); % creates a cube for the derivatives along x
dj=zeros(size(S)); % creates a cube for the derivatives along y
dk=zeros(size(S)); % creates a cube for the derivatives along z
p=zeros(size(S)); % tan of the dip along the inline
q=zeros(size(S)); % tan of the dip along the xline
dip=zeros(size(S)); % dip in degrees
az=zeros(size(S)); %azimuth in degrees
c=zeros(size(S)); % gradient tensor based coherency 
x=zeros(size(S)); % chaos or coherency measure of entropy

%% Calculate di
parfor j=1:nj
    for k=1:nk
    vi=squeeze(S(:,j,k)); %extract a vector along i
    di(:,j,k)=difreg(vi,1,3); % regularized derivative (gaussian filter derivative)
    end
end
fprintf('di - Computation Complete\n');

%% Calculate dj
parfor i=1:ni
    for k=1:nk
    vj=squeeze(S(i,:,k)); %extract a vector along j
    dj(i,:,k)=difreg(vj,1,3); % regularized derivative (gaussian filter derivative)
    end
end
fprintf('dj - Computation Complete\n');

%% Calculate dk
parfor i=1:ni
    for j=1:nj
    vk=squeeze(S(i,j,:)); %extract a vector along k
    dk(i,j,:)=difreg(vk,1,3); % regularized derivative (gaussian filter derivative)
    end
end
fprintf('dk - Computation Complete\n');


%% Looping on each sample in the cube to build the gradient tensor
%h = waitbar(0,'Computing Gradient Tensor...');
wini=1; % max time investigation window
winj=1; %inline investigation window
wink=1; % xline investigation window
parallelstart=tic; %start the clock to time calculation
parfor j=winj+1:nj-winj
    
    %waitbar(j/(nj-(2*winj+2)))

    task=getCurrentTask(); id(j)=task.ID;
    fprintf('Worker %i at position j=%i ---\n',id(j),j);

    
    for k=wink+1:nk-wink
    
            for i=wini+1:ni-wini           
            
            % Compute the smoothed gradient tensor in location j,j,k
            GTS=zeros(3);%the smoothed gradient tensor
            for ii=-wini:wini
                for jj=-winj:winj
                    for kk=-wink:wink
                        V=[di(i+ii,j+jj,k+kk); dj(i+ii,j+jj,k+kk); dk(i+ii,j+jj,k+kk)]; %a 3 dimensional vector captures a measure of waveform variability along the 3 axis
                        GT=V*V'; %this 3x3 covariance matrix is the gradient tensor in i,j.k
                        GTS=GTS+GT; % this is now the averaged gradient tensor over window wini, winj, wink
                    end %kk
                end %jj
            end %ii
            
            %GST estimation of dip
            [V,D] = eigs(GTS,1) % largest eigen value D and corresponding eigen vector V
            % Eigen vector V is the unit vector normal to the seismic event at that location
            % The if block is because you have no guarantee on which 
            % eigenvector you really get out of eigs or eig: is it V or -V? 
            % The if block also limits dips to [0 90] degrees in effect.
            
                if (V(1)<0) 
                    V=-1*V; 
                end
            
            % From V estimate tan of dip along inline and crossline, then dip and az    
            pp=safedivision(V(2),V(1),1); %we are just dividing V(2)/V(1) in a safe way even if V(1) gets very small
            qq=safedivision(V(3),V(1),1); %we are just dividing V(3)/V(1) in a safe way even if V(1) gets very small
            p(i,j,k)=pp;
            q(i,j,k)=qq;
            dip(i,j,k)=180*atan(sqrt(pp^2+qq^2))/pi; %dip in degree assuming cubic bins in x, y, z
            az(i,j,k)=180*atan2(pp,qq)/pi; %Azimuth in degree assuming square bins in x and y
            
            %GST estimate of Coherence and Chaos
            d = eig(GTS); % get the 3 eigen values of GTS
            d=sort(d,'descend');
            c(i,j,k)=(d(1)-d(2))/(d(1)+d(2)); % GST based coherence 
            x(i,j,k)= (2*d(2)/(d(1)+d(3)))-1; % Chaos from Randen et al 2000

            
            end %i
    end %k
end %j

toc(parallelstart)
                