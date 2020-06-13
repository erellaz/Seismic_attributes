%% Compute the instantaneous dip on a 3D cube using the gradient tensor
% Synopsis: S=synthetic_antecline([200,150,100]); S output synthetic cube with an
% anticlinemade from a frist order gaussian (the anticline shape) convolved
% with a 20Hz ricker to look like seismic.
function S=synthetic_antecline(isize)
%% Load the 3D seismic cube
ni=isize(1); 
nj=isize(2);
nk=isize(3);
events=[-45   .3; 
        -20   .7; 
        20      1; 
        60   -.5; 
       90   .8]; % the reflectivity: time shift and reflectivity coef

%% initialization
%S=zeros(ni,nj,nk); %empty synthetic
S=-.005+0.01.*rand(ni,nj,nk); %random noise synthetic
rw = ricker(50); %ricker wavelet
rws=round(size(rw,2)/4);

for jj=1:nj 
    
        scaled=(jj-1)/(nj-1); %in [0 1] now
        scaled=scaled-0.5; %in [-.5 .5] now
        scaled=8*scaled; %in[-4 4]
        time=round(.5*ni*(1-exp(-.5*scaled^2))); % a shifted gaussian        
        for kk=1:nk
        
            for mm=1:size(events,1) %looping on all the reflectivity events
                pos=time+events(mm,1);
                
                if (pos>=1 & pos<= ni) %if they are within the section
                    S(pos,jj,kk)=events(mm,2); % write a reflectivity
                end % if
                
            end %for
            trace=conv(S(:,jj,kk),rw); %convolve refectivities with a ricker
            S(:,jj,kk)=trace(1+rws:ni+rws); %manage the length of the result, doing a better conv(x,y,'same')
        end %k
end %j
                
                