%% Compute semblance through coherence on a 3D cube using analytic signal
% Synopsis: [C,P,Q]=semblance_coherency_analytic(S); 
% with S input seismic, C resulting semblance, P and Q dipscan result 
function [C,P,Q]=semblance_coherency_analytic(S)
%% Initialisation
[ni,nj,nk]=size(S);
C=zeros(size(S)); %Semblance through coherence
P=zeros(size(S)); %Inline dip
Q=zeros(size(S)); %xline dip
winj=1; %inline investigation window
wink=1; % xline investigation window
wini=17; % max time investigation window
wint=4; %time summation window

%% For each trace in the cube compute the analytic signal H
H=zeros(size(S)); % create a cube to host the Analytic Signal
fprintf('Starting parallel computing for analytic signal...'); 
parfor j=1:nj
    %fprintf('At position j=%i -------------------------------------\n',j);
    for k=1:nk
    H(:,j,k)=imag(hilbert(S(:,j,k))); %The traces with a 90 degree phase shift
    end
end
fprintf('done.\n');



%% Looping on each sample in the cube, each dip and each search window 
%h = waitbar(0,'Computing Coherency Semblance...');
fprintf('Starting parallel computing for analytic semblance...\n');
parfor j=winj+1:nj-(winj+1)
    %waitbar(j/(nj-(2*winj+2)))
    task=getCurrentTask(); id(j)=task.ID;
    fprintf('Worker %i at position j=%i ---\n',id(j),j);
    for k=wink+1:nk-(wink+1)
    %fprintf('At position j=%i k=%i\n',j,k);
            for i=wini+1:ni-(wini+1)
            %fprintf('At position i=%i j=%i k=%i\n',i,j,k);   
            %We are on one sample, looping on the 2 dips p and q, and 2
            %investigation windows
            maxval=0; maxvalp=0; maxvalq=0;
            for p=-.0:.25:.0
                for q=-.0:.25:.0
                    %we are on one sample, and have fixed the dips p and q
                    %summing now on the investigation window
                    sumw=0;
                    for w=-wint:wint
                        nums=0; numh=0; denums=0; denumh=0; count=0;
                        for m=-winj:winj
                            for n=-wink:wink
                              s=S(fix(i+w+m*p+n*q),j+m,k+n);
                              h=H(fix(i+w+m*p+n*q),j+m,k+n);
                              nums=nums+s;
                              numh=numh+h;
                              denums=denums+s^2;
                              denumh=denumh+h^2;
                              count=count+1;
                            end %n
                        end %m
                        nums=nums^2;
                        numh=numh^2;
                        curval=(nums+numh)/((denumh+denums)*count);
                        sumw=sumw+curval;
                    end %w
                    sumw=sumw/(2*wint+1);
                        if (sumw>maxval)
                            maxval=sumw; maxvalp=p; maxvalq=q;
                        end %if
                end %q
            end %p
            C(i,j,k)=maxval;
            P(i,j,k)=maxvalp;
            Q(i,j,k)=maxvalq;
            end %i
    end %k
end %j
