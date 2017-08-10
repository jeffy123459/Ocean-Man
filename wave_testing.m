%% SETTINGS %%
save_to_file = 0;

g = 9.81;
dt = .003;

dx = 10;
dz = 10;
nc = 20; % number of coloumns
ni = 5000; % time iterations
depth = 100;
%% INITLIALIZE %%
u = ones(ni,nc+1);
zeta = zeros(ni,nc);
%% CALCULATE %%
for i = 1:nc
    zeta(1,i) = 2*exp(-i^2/nc)+sin(i*2)*5 ;    
end

for i = 1:nc+1
    u(1,i) = 5*exp(-i^2/200)+sin(3*i/nc);
end

u(:,1) = 0; % wall boundaries
u(:,nc+1) = 0;

for t = 2:1:ni
    % stepping time 

    for c2 = 1:nc
        % adjust heights
        % d = depth - log(c2.^2+1)*9*exp(-c2.^2/3000)+1;
        % I was testing variable depth ^ 
        % https://www.desmos.com/calculator/nmj3rregqr
        
        % zeta(t, c2) = -d*dt*( u(t-1, c2+1) - u(t-1, c2))/dz + zeta(t-1, c2);
        
        zeta(t, c2) = -depth*dt*( u(t-1, c2+1) - u(t-1, c2))/dz + zeta(t-1, c2);
    end
    
    for c = 2:nc 
        % note that the actual length of u is nc+1 -we are keeping the left and right sides as 0
        % adjust velocities
        u(t, c) = -g*dt*(zeta(t-1, c)-zeta(t-1, c-1))/dx + u(t-1, c);
    end  
end
%% DRAW %%
if save_to_file
    vidObj = VideoWriter('nice waves');
    open(vidObj);
    figure
    % x = 1:nc;
    % y = log(x.^2+1)*5.*exp(-x.^2/3000)+1;

    for i = 1:ni
        plot(depth+interp(zeta(i,:),2));
        hold on
        plot(x,y);
        hold off
        axis([0 nc 0 depth + 26 ])
        F(i) = getframe(gcf);
        writeVideo(vidObj,F(i));
    end
    close(vidObj)
else    
    figure
    % x = 1:nc;
    % y = log(x.^2+1)*5.*exp(-x.^2/3000)+1;
    for i = 1:ni 
        plot(depth+interp(zeta(i,:),2));
        % hold on
        % plot(x,y);
        % hold off
        axis([0 nc 0+depth/3 depth + 26 ])
        pause(0);
    end
end




