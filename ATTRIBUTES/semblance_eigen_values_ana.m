%% Compute semblance through eigen values decomposition of the local covariance matrix on a 3D cube
% Synopsis: [C,P,Q]=semblanceeigen_values_ana(S); 
% with S input seismic, C resulting semblance, P and Q dipscan result 
function [C,P,Q]=semblance_eigen_values_ana(S)
%% Initialisation
[ni,nj,nk]=size(S);
C=zeros(size(S)); %Semblance through eigenvalues
P=zeros(size(S)); %Inline dip
Q=zeros(size(S)); %xline dip
winj=1; %inline investigation window
wink=1; % xline investigation window
wini=17; % max time investigation window
wint=3; %time summation window
covsize=(2*winj+1)*(2*wink+1);%size of the correlation matrix

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
%h = waitbar(0,'Computing Coherency though eigen values of the local correlation matrix...');
parallelstart=tic; %start the clock to time calculation
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
            for p=-0.0:.5:0.0
                for q=-0.0:.5:0.0
                    %we are on one sample, and have fixed the dips p and q
                    %summing now on the investigation window
                    
                    %prepare the vectors to build the correlation matrix
                    as=zeros(covsize,2*wint+1);
                    ah=zeros(covsize,2*wint+1);
                    for w=-wint:wint
                        count=1;
                        for m=-winj:winj
                            for n=-wink:wink
                              as(count,w+wint+1)=S(fix(i+w+m*p+n*q),j+m,k+n);
                              ah(count,w+wint+1)=H(fix(i+w+m*p+n*q),j+m,k+n);
                              count=count+1;
                            end %n
                        end %m
                    end %w
                    
                    %Prepare the correlation matrix
                    covmat=zeros(covsize);
                    for ii=1:covsize
                        for jj=1:covsize
                        covmat(ii,jj)=dot(as(ii,:),as(jj,:))+dot(ah(ii,:),ah(jj,:));
                        end %jj
                    end %ii
                    
                    %Diagonalize the correlation matrix and find the
                    %biggest eigenvalue
                        % Theorem 1: the covariance matrix is positive semi
                        % definite and hermitian by construction.
                        % Theroem 2: all eigen vals are real because covmat
                        % is hermitian.
                        % Theorem 3: all eigens vals are non negative
                        % because covmat is positive semi definite. 
                    lambda=max(eig(covmat));
                        % Theorem 4: the total variance of a covariance 
                        % matrix is the trace, hence the normalization.
                    lambda=lambda/trace(covmat);
                    
                        if (lambda>maxval)
                            maxval=lambda; maxvalp=p; maxvalq=q;
                        end %if
                end %q
            end %p
            C(i,j,k)=maxval;
            P(i,j,k)=maxvalp;
            Q(i,j,k)=maxvalq;
            end %i
    end %k
end %j
toc(parallelstart)
