%vz2xt.m
% Computes primary reflections from all layer interfaces, 
% plus possible diving wave in gradient zone.
% Critical reflection times will be recognized as negative.
% Diving wave travel times will be recognized as imaginary.
% INPUTS:
% p   : ray parameter sin(theta)/v
% v   : velocities in layers
% z   : layer interface depths. 
% mode: string. 
%       mode(1)='h': homogeneous layers are assumed: 
%                    v(i) constant between z(i) and z(i+1)
%       mode(1)='g': gradient layers are assumed, where v grades 
%                    from v(2*i-1) to v(2*i) between z(i) and z(i+1)
% OUTPUTS:                   
% xs   : distances from source where ray is reflected/turns
% ts   : travel times from source to positions xs
% zs   : depths where ray was reflected or turned
% CALL
%        [xs,ts,zs]=vz2xt(p,v,z,mode);
function [xs,ts,zs]=vz2xt(p,v,z,mode)
rayturn = 'no'; %changes if ray turns above last layer

% allocate 
lenz = length(z)-1;

dz = zeros(1,lenz);
dx = zeros(1,lenz);
dt = zeros(1,lenz);

if mode(1)=='h'
   % Computation for constant velocity layers
   % Use elementary formula like Fowler eq. (4.100)
   
   % Check that the number of boundaries matches the number of interval velocities
   if length(z)~=length(v)+1
      disp('vz2xt: mode = ''h''; homogeneous intervals:');
      warning(['Number of interfaces (=',num2str(length(z)),...
            ') should be 1.0 larger than number of interval velocities (=',num2str(length(v)),')']);
   end
   
   % Check that the ray can travel in the first layer at all
   if abs(p)>1/v(1)
      warning('vz2xt: p>v(1); ray does not enter.')
   end
   
   %Then start the loop over layers
   for i=1:lenz
      if abs(p)>1/v(i)
         %critical reflection just above layer
         rayturn = 'critical';
        break
      end
      %compute oneway travel time from z(i) to z(i+1)
      dz(i) = z(i+1)-z(i);
      dx(i) = dz(i)*p*v(i)/sqrt(1-(p*v(i))^2);
      dt(i) = dz(i)/(v(i)*sqrt(1-(p*v(i))^2));
   end
   xs = [0,cumsum(dx)];
   ts = [0,cumsum(dt)];
   zs = [0,cumsum(dz)];
   %if strcmp(rayturn,'diving')
   if rayturn(1) == 'd'
      ts(length(ts)) = sqrt(-1)*ts(length(ts)); %remember: imaginary time signals diving rayturn
   %elseif strcmp(rayturn,'critical')
   elseif rayturn(1) == 'c'
      ts(length(ts)) = -ts(length(ts)); %remember: negative time signals critically reflected rayturn
   end

elseif mode(1)=='g'
   % Computation for velocity gradients
   
   % Check number of velocities against number of interfaces
   if length(v)~=2*(length(z)-1)
      disp('vz2xt: mode = ''g''; gradient intervals:')
      warning(['Number of interfaces (=',num2str(length(z)),...
            ') minus 1.0 should equal twice the number of interval velocities (=',num2str(length(v)),')']);
   end
   if p>1/v(1)
      warning('vz2xt: p>v(1); ray does not enter.')
   end
   
   %Then start the loop over layers
   for i=1:length(z)-1
      if p>1/v(2*i-1)
         %ray does not enter; critical reflection at top of layer
         rayturn = 'critical';
         break
      elseif v(2*i-1)==v(2*i) %homogeneous layer
         h = z(i+1)-z(i);
         dx(i) = h*p*v(i)/sqrt(1-(p*v(i))^2);
         dt(i) = h/(v(i)*sqrt(1-(p*v(i))^2));
      else % gradient zone entered 
         b    = v(2*i-1); %velocity at the top of the layer
         beta = v(2*i);   %velocity at the bottom of the layer
         h = z(i+1)-z(i);
         gamma = (beta-b)/h;
         if p>1/v(2*i)
           %ray turns in layer
           rayturn = 'diving';
           % traveltime to turning point; Gibson et al. 3a + 3b
           dx(i)=1/(p*gamma) * sqrt(1-p^2*b^2);
           dt(i)=1/gamma * log((1+sqrt(1-p^2*b^2))/(p*b));
           dz(i)=(1/p - b)/gamma;
           break
         else
           %ray travels to the bottom of current layer
           %compute oneway traveltime from z(i) to z(i+1)
           dx(i) = 1/(p*gamma) * (sqrt(1-(p*b)^2)-sqrt(1-(p*beta)^2));
           dt(i) = 1/gamma * log((beta*(1+sqrt(1-p^2*b^2)))/(b*(1+sqrt(1-p^2*beta^2))));
           dz(i) = h;
        end
      end %else gradient zone entered     
   end %loop over layers; some dx and dt have been computed
   xs = [0,cumsum(dx)];
   ts = [0,cumsum(dt)];
   zs = [0,cumsum(dz)];
   if strcmp(rayturn,'diving')
      ts(length(ts)) = sqrt(-1)*ts(length(ts)); %remember: imaginary time signals diving rayturn
   elseif strcmp(rayturn,'critical')
      ts(length(ts)) = -ts(length(ts)); %remember: negative time signals critically reflected rayturn
   end
else
   error(['vz2xt: mode(1)=''',mode(1),'''. Must be ''h'' or ''g''']);
end
