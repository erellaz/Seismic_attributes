%% Compute first derivative using regularization
% Synopsis: du = difreg(u,1,3); for a 7 points operator
% u: input signal, du: first derivative, sigma: scale parameter,
% length; half size of the filter in number of sigmas, sigma is the test
% function spread (std deviation)
%
% The differentiation operator is notorious to become instable in presence 
% of noise. Regularization (Schwartz, Florack) transerts the differentiation
% to a filter that is convolved with the data. 
% For a well behaved function: (f*g)'=f'*g=g'*f so derivation of the smoothing
% filter f or of the signal g are equivalent. For an unstable functions the 2 
% are not equivalent and derivation of the filter is more stable if f meets 
% Schwartz criterias.
% For this implementation we use the first derivative of the gaussian kernel
% as the test function.

function du = difreg(u,sigma,length)

% If Sigma is zero, then default the unregularized finite difference
if sigma==0
    dd=diff(u); %calculate the first differental, it shrinks 
    du=[dd(:); dd(size(dd))]; %fix the shrink

else
    % Build the derivative of the Gaussian
    i=1; t=zeros(1,6*sigma+1); g=zeros(1,6*sigma+1); dg=zeros(1,6*sigma+1);
    for x=-length*sigma:1:length*sigma
    t(i)=x;
    %g(i) =exp(-x^2/(2*sigma^2))/(sigma*sqrt(2*pi)); %the gaussian
    dg(i)=-x*exp(-x^2/(2*sigma^2))/(sigma^3*sqrt(2*pi)); %the derivative of the gaussian
    i=i+1;
    end %for x
    %plot(t,g,t,dg);
    
    du=conv(u,dg,'same'); %the regularized derivation has become a convolution with the first derivative of the gaussian
end

% Test:
% trace=R(:,100,100);
% d = difreg(trace,0,3);
% du = difreg(trace,1,3);
% plot(trace); figure; plot(d); figure; plot(du);