%% Computes volumetric curvature attributs
% Synopsis: [kneg,kpos,kmean,kgauss]=curvature(p,q);  p inline dip
% q crossline dip, k curvatures
function [kneg,kpos,kmean,kgauss]=curvature(p,q);
%% Load the 3D seismic cube
[ni,nj,nk]=size(p);

%% initialization
kneg=zeros(size(p)); % creates a cube for the most negative curvature
kpos=zeros(size(p)); % creates a cube for the most positive curvature
kmean=zeros(size(p)); % creates a cube for the mean curvature
kgauss=zeros(size(p)); % creates a cube for the gaussian curvature
a=zeros(size(p)); % creates a cube for the a parameter of the local quadratic surface
b=zeros(size(p)); % creates a cube for the b parameter of the local quadratic surface
c1=zeros(size(p)); % creates a cube for the c parameter of the local quadratic surface
c2=zeros(size(p)); % creates a cube for the c parameter of the local quadratic surface



%% Calculate a
parfor i=1:ni
    for k=1:nk
    vj=squeeze(p(i,:,k)); %extract a vector along j
    wj=squeeze(q(i,:,k)); %extract a vector along j
    a(i,:,k)=.5.*difreg(vj,1,3); % regularized derivative (gaussian filter derivative) this is .5*dp/dx
   c1(i,:,k)=.5.*difreg(wj,1,3); % regularized derivative (gaussian filter derivative) this is .5*dq/dx
    end
end
fprintf('dp/dx and dq/dx - Computation Complete\n');

%% Calculate b
parfor i=1:ni
    for j=1:nj
    vk=squeeze(q(i,j,:)); %extract a vector along k
    wj=squeeze(p(i,j,:)); %extract a vector along j
    b(i,j,:)=.5.*difreg(vk,1,3); % regularized derivative (gaussian filter derivative) this is .5*dq/dy
   c2(i,j,:)=.5.*difreg(wj,1,3); % regularized derivative (gaussian filter derivative) this is .5*dp/dy
    end
end
fprintf('dq/dy and dp/dy - Computation Complete\n');



%% Looping on each sample in the cube to calculate the curvatures
%h = waitbar(0,'Computing Gradient Tensor...');

parallelstart=tic; %start the clock to time calculation
parfor j=1:nj
    
    %waitbar(j/(nj-(2*winj+2)))
    task=getCurrentTask(); id(j)=task.ID;
    fprintf('Worker %i at position j=%i ---\n',id(j),j);
    
    for k=1:nk
    
            for i=1:ni   
            % For lisibility and access speed the quadratic surface is
            % redefined here
            aa=a(i,j,k);
            bb=b(i,j,k);
            cc=c1(i,j,k)+c2(i,j,k);
            dd=p(i,j,k);
            ee=q(i,j,k);
            
            kneg(i,j,k)=(aa+bb)-sqrt((aa-bb)^2+cc^2);
            kpos(i,j,k)=(aa+bb)+sqrt((aa-bb)^2+cc^2);
            kmean(i,j,k)=(aa*(1+ee^2)+bb*(1+dd^2)-cc*dd*ee)/(1+dd^2+ee^2)^1.5;
            kgauss(i,j,k)=(4*aa*bb-cc^2)/(1+dd^2+ee^2)^2;
            
            end %i
    end %k
end %j

toc(parallelstart)
                